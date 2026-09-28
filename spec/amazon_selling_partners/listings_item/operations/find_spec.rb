# frozen_string_literal: true

require 'spec_helper'
require 'amazon_selling_partners/listings_item/operations/find'

RSpec.describe AmazonSellingPartners::ListingsItem::Operation::Find do
  subject(:operation) { described_class.new(client:, resource:) }

  let(:client) { build(:client) }
  let(:resource) do
    AmazonSellingPartners::ListingsItem.new(seller_id: 'ASELLER', sku: '697821896',
                                            marketplace_id: 'A2VIGQ35RCS4UG')
  end
  let(:item_url) { %r{\Ahttps://sellingpartnerapi-eu\.amazon\.com/listings/2021-08-01/items/ASELLER/697821896} }

  before do
    stub_request(:post, 'https://api.amazon.com/auth/o2/token')
      .to_return(status: 200, body: { access_token: 'Atza|token', expires_in: 3600 }.to_json)
  end

  it 'returns the listing summaries and issues' do
    stub_request(:get, item_url)
      .with(query: { marketplaceIds: 'A2VIGQ35RCS4UG', includedData: 'summaries,issues' })
      .to_return(status: 200, body: {
        sku: '697821896', summaries: [{ 'asin' => 'B0DNDS8C2X', 'status' => ['BUYABLE'] }], issues: []
      }.to_json)

    operation.perform

    expect(operation.result.resource.summaries.first).to include('status' => ['BUYABLE'])
  end

  it 'fails with NotFound when the seller has no such SKU' do
    stub_request(:get, item_url).with(query: hash_including({})).to_return(status: 404, body: '{}')

    operation.perform

    expect(operation.result.error).to be_a(AmazonSellingPartners::Errors::NotFound)
  end
end
