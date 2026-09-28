# frozen_string_literal: true

require 'spec_helper'
require 'amazon_selling_partners/listings_item/operations/put'

# rubocop:disable Metrics/BlockLength

RSpec.describe AmazonSellingPartners::ListingsItem::Operation::Put do
  subject(:operation) { described_class.new(client:, resource:) }

  let(:client) { build(:client) }
  let(:marketplace_id) { 'A2VIGQ35RCS4UG' }
  let(:mode) { AmazonSellingPartners::ListingsItem::VALIDATION_PREVIEW }
  let(:listing_attributes) do
    {
      merchant_suggested_asin: [{ value: 'B0DNDS8C2X', marketplace_id: }],
      condition_type: [{ value: 'new_new', marketplace_id: }]
    }
  end
  let(:resource) do
    AmazonSellingPartners::ListingsItem.new(
      seller_id: 'ASELLER', sku: '697821896', marketplace_id:, product_type: 'PRODUCT',
      requirements: 'LISTING_OFFER_ONLY', listing_attributes:, mode:
    )
  end
  let(:item_url) { %r{\Ahttps://sellingpartnerapi-eu\.amazon\.com/listings/2021-08-01/items/ASELLER/697821896} }

  def stub_token(status: 200, body: { access_token: 'Atza|token', token_type: 'bearer', expires_in: 3600 })
    stub_request(:post, 'https://api.amazon.com/auth/o2/token')
      .to_return(status:, body: body.to_json, headers: {})
  end

  def stub_put(status: 200, body: {}, query: { marketplaceIds: marketplace_id, includedData: 'issues', mode: })
    stub_request(:put, item_url)
      .with(query: query.compact)
      .to_return(status:, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  before { stub_token }

  it 'validates an offer-only listing without saving it' do
    request = stub_put(body: { sku: '697821896', status: 'VALID', submissionId: 'abc', issues: [] })

    operation.perform

    expect(request).to have_been_requested
    expect(operation.result.resource).to have_attributes(status: 'VALID', submission_id: 'abc', issues: [])
    expect(
      a_request(:put, item_url).with(
        body: { productType: 'PRODUCT', requirements: 'LISTING_OFFER_ONLY',
                attributes: listing_attributes }.to_json
      )
    ).to have_been_made
  end

  it 'returns the issues of a rejected submission' do
    issue = { code: '90220', message: 'Brand approval required', severity: 'ERROR', categories: [] }
    stub_put(body: { sku: '697821896', status: 'INVALID', submissionId: 'abc', issues: [issue] })

    operation.perform

    expect(operation).to be_success
    expect(operation.result.resource.status).to eq('INVALID')
    expect(operation.result.resource.issues.first).to include('code' => '90220', 'severity' => 'ERROR')
  end

  context 'without a mode' do
    let(:mode) { nil }

    it 'submits for real' do
      request = stub_put(body: { sku: '697821896', status: 'ACCEPTED', submissionId: 'abc' },
                         query: { marketplaceIds: marketplace_id, includedData: 'issues' })

      operation.perform

      expect(request).to have_been_requested
      expect(operation.result.resource.status).to eq('ACCEPTED')
    end
  end

  it 'classifies a rejected token' do
    stub_request(:put, item_url).with(query: hash_including({})).to_return(status: 403, body: '{}')

    operation.perform

    expect(operation.result.error).to be_a(AmazonSellingPartners::Errors::Unauthorized)
  end
end

# rubocop:enable Metrics/BlockLength
