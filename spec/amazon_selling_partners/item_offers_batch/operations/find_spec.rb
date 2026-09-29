# frozen_string_literal: true

require 'spec_helper'
require 'amazon_selling_partners/item_offers_batch/operations/find'

# rubocop:disable Metrics/BlockLength

RSpec.describe AmazonSellingPartners::ItemOffersBatch::Operation::Find do
  subject(:operation) { described_class.new(client:, resource:) }

  let(:client) { build(:client) }
  let(:marketplace_id) { 'A2VIGQ35RCS4UG' }
  let(:asins) { %w[B0DTKCN3Z4 B000EMPTY1 BADASIN000] }
  let(:resource) { AmazonSellingPartners::ItemOffersBatch.new(market_place_id: marketplace_id, asins:) }
  let(:batch_url) { 'https://sellingpartnerapi-eu.amazon.com/batches/products/pricing/v0/itemOffers' }

  let(:offers_body) do
    {
      'payload' => {
        'ASIN' => 'B0DTKCN3Z4',
        'status' => 'Success',
        'ItemCondition' => 'New',
        'Summary' => { 'TotalOfferCount' => 2 },
        'Offers' => [
          {
            'SellerId' => 'A2M3I7Y6VFH2XN',
            'SubCondition' => 'new',
            'ListingPrice' => { 'Amount' => 116.0, 'CurrencyCode' => 'AED' },
            'Shipping' => { 'Amount' => 0.0, 'CurrencyCode' => 'AED' },
            'ShipsFrom' => { 'Country' => 'US' },
            'IsFulfilledByAmazon' => false,
            'IsBuyBoxWinner' => true,
            'PrimeInformation' => { 'IsPrime' => false, 'IsNationalPrime' => false }
          },
          {
            'SellerId' => 'A1LOCALFBA0000',
            'SubCondition' => 'new',
            'ListingPrice' => { 'Amount' => 129.0, 'CurrencyCode' => 'AED' },
            'Shipping' => { 'Amount' => 0.0, 'CurrencyCode' => 'AED' },
            'IsFulfilledByAmazon' => true,
            'IsBuyBoxWinner' => false,
            'PrimeInformation' => { 'IsPrime' => true, 'IsNationalPrime' => true }
          }
        ]
      }
    }
  end

  let(:batch_response) do
    {
      'responses' => [
        {
          'status' => { 'statusCode' => 200, 'reasonPhrase' => 'OK' },
          'body' => offers_body,
          'request' => { 'MarketplaceId' => marketplace_id, 'Asin' => 'B0DTKCN3Z4', 'ItemCondition' => 'New' }
        },
        {
          'status' => { 'statusCode' => 200, 'reasonPhrase' => 'OK' },
          'body' => {
            'payload' => {
              'ASIN' => 'B000EMPTY1', 'status' => 'NoBuyableOffers',
              'Summary' => { 'TotalOfferCount' => 0 }, 'Offers' => []
            }
          },
          'request' => { 'MarketplaceId' => marketplace_id, 'Asin' => 'B000EMPTY1', 'ItemCondition' => 'New' }
        },
        {
          'status' => { 'statusCode' => 400, 'reasonPhrase' => 'Bad Request' },
          'body' => { 'errors' => [{ 'code' => 'InvalidInput', 'message' => 'Invalid ASIN BADASIN000' }] },
          'request' => { 'MarketplaceId' => marketplace_id, 'ItemCondition' => 'New',
                         'uri' => '/products/pricing/v0/items/BADASIN000/offers' }
        }
      ]
    }
  end

  def stub_token(status: 200, body: { access_token: 'Atza|token', token_type: 'bearer', expires_in: 3600 })
    stub_request(:post, 'https://api.amazon.com/auth/o2/token')
      .to_return(status:, body: body.to_json, headers: {})
  end

  before { stub_token }

  context 'when Amazon answers every item' do
    before do
      stub_request(:post, batch_url)
        .to_return(status: 200, body: batch_response.to_json,
                   headers: { 'x-amzn-RateLimit-Limit' => '0.1', 'Content-Type' => 'application/json' })
    end

    it 'sends one ASIN-keyed request per item' do
      operation.perform

      expect(
        a_request(:post, batch_url).with do |req|
          requests = JSON.parse(req.body)['requests']
          requests.map { |r| r['uri'] } == asins.map { |asin| "/products/pricing/v0/items/#{asin}/offers" } &&
            requests.all? do |r|
              r['method'] == 'GET' && r['MarketplaceId'] == marketplace_id && r['ItemCondition'] == 'New'
            end
        end
      ).to have_been_made.once
    end

    it 'returns one ProductPricing per ASIN with offers and status' do
      operation.perform

      expect(operation).to be_success
      items = operation.result.resource.items
      expect(items.map(&:asin)).to eq(asins)
      expect(items.map(&:status_code)).to eq([200, 200, 400])

      offered = items.first
      expect(offered.total_offer_count).to eq(2)
      expect(offered.offers.map(&:seller_id)).to eq(%w[A2M3I7Y6VFH2XN A1LOCALFBA0000])
      expect(offered.offers.first).to have_attributes(price: 116.0, currency: 'AED', buybox_winner: true,
                                                      is_prime: false, is_fulfilled_by_amazon: false)
      expect(offered.offers.last).to have_attributes(is_prime: true, is_fulfilled_by_amazon: true)
    end

    it 'keeps the ASIN and error for failed items' do
      operation.perform

      failed = operation.result.resource.items.last
      expect(failed).to have_attributes(asin: 'BADASIN000', status_code: 400, error_code: 'InvalidInput',
                                        error_message: 'Invalid ASIN BADASIN000')
      expect(failed.offers).to be_empty
    end

    it 'records the rate limit Amazon reports' do
      operation.perform

      expect(operation.result.resource.rate_limit).to eq(0.1)
    end
  end

  {
    429 => AmazonSellingPartners::Errors::Throttled,
    403 => AmazonSellingPartners::Errors::Unauthorized,
    401 => AmazonSellingPartners::Errors::Unauthorized,
    503 => AmazonSellingPartners::Errors::ServerError,
    400 => AmazonSellingPartners::Errors::RequestError
  }.each do |status, error_class|
    context "when the batch call returns #{status}" do
      before do
        stub_request(:post, batch_url)
          .to_return(status:, body: { errors: [{ code: 'Error', message: 'nope' }] }.to_json)
      end

      it "fails with #{error_class.name.demodulize}" do
        operation.perform

        expect(operation).to be_failure
        expect(operation.result.error).to be_an_instance_of(error_class)
        expect(operation.result.error.status).to eq(status)
      end
    end
  end

  context 'when the refresh token is rejected' do
    before { stub_token(status: 400, body: { error: 'invalid_grant', error_description: 'revoked' }) }

    it 'fails with Unauthorized without calling the batch endpoint' do
      operation.perform

      expect(operation).to be_failure
      expect(operation.result.error).to be_an_instance_of(AmazonSellingPartners::Errors::Unauthorized)
      expect(a_request(:post, batch_url)).not_to have_been_made
    end
  end

  context 'when the token endpoint does not answer' do
    before { stub_request(:post, 'https://api.amazon.com/auth/o2/token').to_timeout }

    it 'fails with ServerError, not Unauthorized' do
      operation.perform

      expect(operation.result.error).to be_an_instance_of(AmazonSellingPartners::Errors::ServerError)
      expect(a_request(:post, batch_url)).not_to have_been_made
    end
  end

  context 'when the batch call times out' do
    before { stub_request(:post, batch_url).to_timeout }

    it 'fails with ServerError' do
      operation.perform

      expect(operation.result.error).to be_an_instance_of(AmazonSellingPartners::Errors::ServerError)
    end
  end

  context 'with more ASINs than one batch allows' do
    let(:asins) { Array.new(21) { |i| format('B%09d', i) } }

    it 'fails without calling Amazon' do
      operation.perform

      expect(operation).to be_failure
      expect(operation.result.error.message).to include('got 21')
      expect(a_request(:post, batch_url)).not_to have_been_made
    end
  end
end
# rubocop:enable Metrics/BlockLength
