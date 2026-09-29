# frozen_string_literal: true

require 'spec_helper'
require 'amazon_selling_partners/listings_restrictions/operations/find'

# rubocop:disable Metrics/BlockLength

RSpec.describe AmazonSellingPartners::ListingsRestrictions::Operation::Find do
  subject(:operation) { described_class.new(client:, resource:) }

  let(:client) { build(:client) }
  let(:resource) do
    AmazonSellingPartners::ListingsRestrictions.new(asin: 'B0DPHSHY15', seller_id: 'ASELLER',
                                                    marketplace_id: 'A2VIGQ35RCS4UG')
  end
  let(:query) do
    { asin: 'B0DPHSHY15', sellerId: 'ASELLER', marketplaceIds: 'A2VIGQ35RCS4UG',
      reasonLocale: 'en_US', conditionType: 'new_new' }
  end
  let(:url) { 'https://sellingpartnerapi-eu.amazon.com/listings/2021-08-01/restrictions' }

  before do
    stub_request(:post, 'https://api.amazon.com/auth/o2/token')
      .to_return(status: 200, body: { access_token: 'Atza|token', expires_in: 3600 }.to_json)
  end

  it 'returns the reasons an ASIN cannot be listed' do
    reason = { 'reasonCode' => 'APPROVAL_REQUIRED', 'message' => 'You need approval to list this brand.' }
    stub_request(:get, url).with(query:).to_return(
      status: 200,
      body: { restrictions: [{ marketplaceId: 'A2VIGQ35RCS4UG', conditionType: 'new_new', reasons: [reason] }] }.to_json
    )

    operation.perform

    expect(operation.result.resource.restrictions.first['reasons']).to eq([reason])
  end

  it 'returns no restrictions when the seller can list it' do
    stub_request(:get, url).with(query:).to_return(status: 200, body: { restrictions: [] }.to_json)

    operation.perform

    expect(operation.result.resource.restrictions).to eq([])
  end

  it 'classifies throttling' do
    stub_request(:get, url).with(query:).to_return(status: 429, body: '{}')

    operation.perform

    expect(operation.result.error).to be_a(AmazonSellingPartners::Errors::Throttled)
  end
end

# rubocop:enable Metrics/BlockLength
