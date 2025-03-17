# frozen_string_literal: true

FactoryBot.define do
  factory :client, class: 'AmazonSellingPartners::Client' do
    transient do
      debug { false }
      region { 'eu' }
      refresh_token { 'refresh_token' }
      client_id { 'amzn1.application-oa2-client.client_id' }
      client_secret { 'amzn1.oa2-cs.v1.client_secret' }
      aws_access_key_id { 'aws_access_key_id' }
      aws_secret_access_key { 'aws_secret_access_key' }
      sandbox { false }
    end

    initialize_with do
      new(
        debug: debug,
        region: region,
        refresh_token: refresh_token,
        client_id: client_id,
        client_secret: client_secret,
        aws_access_key_id: aws_access_key_id,
        aws_secret_access_key: aws_secret_access_key,
        sandbox: sandbox
      )
    end
  end
end
