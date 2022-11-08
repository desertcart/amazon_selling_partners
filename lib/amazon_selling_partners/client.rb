# frozen_string_literal: true

require 'uri'
require 'date'
require 'json'
require 'logger'
require 'tempfile'
require 'typhoeus'
require 'aws-sigv4'
require_relative './errors/auth_error'

module AmazonSellingPartners
  class Client # rubocop:disable Metrics/ClassLength
    include LedgerSync::Ledgers::Client::Mixin
    attr_reader :asp_endpoint, :client_id, :client_secret, :aws_access_key_id,
                :aws_secret_access_key, :region, :refresh_token, :sandbox, :debug,
                :save_access_token, :get_access_token # lambdas

    AWS_REGION_MAP = {
      'na' => 'us-east-1',
      'eu' => 'eu-west-1',
      'fe' => 'us-west-2'
    }.freeze

    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json',
      'User-Agent' => 'Swagger-Codegen/0.0.1/ruby',
      'Expect' => '',
      'Accept' => 'application/json'
    }.freeze

    API_ENDPOINT = 'https://api.amazon.com'

    def initialize(sandbox: false, region: 'na', client_id: nil, client_secret: nil, # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists:
                   refresh_token: nil, aws_access_key_id: nil, aws_secret_access_key: nil,
                   save_access_token: nil, get_access_token: nil, debug: false)
      @asp_endpoint = "https://#{sandbox ? 'sandbox.' : ''}sellingpartnerapi-#{region}.amazon.com"
      @client_id = client_id
      @client_secret = client_secret
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
      @region = region
      @refresh_token = refresh_token
      @sandbox = sandbox
      @debug = debug
      @get_access_token = get_access_token
      @save_access_token = save_access_token
    end

    def generate_authorization_url(
      application_id:, # Our application id, looks like amzn1.sellerapps.app.0bf296b5-36a6-4942-a13e-random
      state:, # A unique, short-lived value that is associated with our user.
      redirect_uri: nil, # Optional, defaults to the first redirect url you've registered on your app
      seller_central_url: 'https://sellercentral.amazon.com', # https://developer-docs.amazon.com/sp-api/docs/seller-central-urls,
      draft: false # Set to true if our application is still in draft mode
    )
      params = {
        application_id:, state:, redirect_uri:, version: draft ? 'beta' : nil
      }.compact

      "#{seller_central_url}/apps/authorize/consent?#{URI.encode_www_form(params)}"
    end

    def exchange_auth_code_for_refresh_token(auth_code:) # rubocop:disable Metrics/MethodLength
      data, status_code, headers = call_api(
        :POST, '/auth/o2/token',
        header_params: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        form_params: {
          grant_type: 'authorization_code',
          code: auth_code,
          client_id:,
          client_secret:
        }
      )

      unless data && data[:refresh_token]
        raise AmazonSellingPartners::Errors::AuthError.new(code: status_code, response_headers: headers,
                                                           response_body: data)
      end

      data[:refresh_token]
    end

    def api(http_method, path, opts = {}) # rubocop:disable Metrics/MethodLength
      unsigned_request = build_request(http_method, path, opts:)
      aws_headers = auth_headers(http_method, unsigned_request.url, unsigned_request.encoded_body)
      signed_opts = opts.merge(header_params: aws_headers.merge(opts[:header_params] || {}))

      request = LedgerSync::Ledgers::Request.new(
        body: signed_opts.fetch(:body),
        headers: signed_opts.fetch(:header_params).merge(DEFAULT_HEADERS),
        method: http_method,
        url: asp_endpoint + path,
        params: signed_opts.fetch(:form_params)
      )

      request.perform
    end

    def call_api(http_method, path, opts = {}) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      request = build_request(http_method, path, asp: false, opts:)
      response = request.run

      puts "HTTP response body ~BEGIN~\n#{response.body}\n~END~\n" if debug

      unless response.success?
        if response.timed_out?
          puts 'Connection timed out'
        elsif response.code.zero?
          puts response.return_message
        else
          puts 'Api Error'
        end
      end

      data = JSON.parse("[#{response.body}]", symbolize_names: true)[0]
      [data, response.code, response.headers]
    end

    private

    def access_token_key
      Digest::MD5.hexdigest("#{client_id} #{refresh_token}")
    end

    def request_lwa_access_token # rubocop:disable Metrics/MethodLength
      data, status_code, headers = call_api(
        :POST, '/auth/o2/token',
        header_params: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        form_params: {
          grant_type: 'refresh_token',
          refresh_token:,
          client_id:,
          client_secret:
        }
      )

      unless data && data[:access_token]
        raise StandardError, { code: status_code,
                               response_headers: headers,
                               response_body: data }.to_s
      end
      data
    end

    def retrieve_lwa_access_token
      return request_lwa_access_token[:access_token] unless get_access_token

      stored_token = get_access_token.call(access_token_key)
      return stored_token if stored_token

      new_token = request_lwa_access_token
      save_access_token&.call(access_token_key, new_token)
      new_token[:access_token]
    end

    def build_request(http_method, path, asp: true, opts: {}) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      base_url = asp ? asp_endpoint : API_ENDPOINT
      url = base_url + path
      http_method = http_method.to_sym.downcase

      header_params = DEFAULT_HEADERS.merge(opts[:header_params] || {})
      query_params = opts[:query_params] || {}
      form_params = opts[:form_params] || {}

      req_opts = {
        method: http_method,
        headers: header_params,
        params: query_params,
        params_encoding: nil,
        timeout: 20,
        ssl_verifypeer: true,
        ssl_verifyhost: 2,
        sslcert: nil,
        sslkey: nil,
        verbose: debug
      }

      if %i[post patch put delete].include?(http_method)
        req_body = build_request_body(header_params, form_params, opts[:body])
        req_opts.update body: req_body
        puts "HTTP request body param ~BEGIN~\n#{req_body}\n~END~\n" if debug
      end

      Typhoeus::Request.new(url, req_opts)
    end

    def build_request_body(header_params, form_params, body) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
      if header_params['Content-Type'] == 'application/x-www-form-urlencoded' ||
         header_params['Content-Type'] == 'multipart/form-data'
        data = {}
        form_params.each do |key, value|
          data[key] = case value
                      when ::File, ::Array, nil
                        value
                      else
                        value.to_s
                      end
        end
        data
      elsif header_params['Content-Type'] == 'application/json'
        body.to_json
      elsif body
        body.is_a?(String) ? body : body.to_json
      end
    end

    def signed_request_headers(http_method, url, body)
      request_config = {
        service: 'execute-api',
        region: AWS_REGION_MAP[region]
      }

      request_config[:access_key_id] = aws_access_key_id
      request_config[:secret_access_key] = aws_secret_access_key
      signer = Aws::Sigv4::Signer.new(request_config)
      signer.sign_request(http_method: http_method.to_s, url:, body:).headers
    end

    def auth_headers(http_method, url, body)
      signed_request_headers(http_method, url, body)
        .merge({
                 'x-amz-access-token' => retrieve_lwa_access_token
               })
    end
  end
end
