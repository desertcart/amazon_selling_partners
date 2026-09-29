# frozen_string_literal: true

require 'spec_helper'
require 'amazon_selling_partners/listings_item/operations/delete'

# rubocop:disable Metrics/BlockLength

RSpec.describe AmazonSellingPartners::ListingsItem::Operation::Delete do
  subject(:operation) { described_class.new(client:, resource:) }

  let(:client) { build(:client) }
  let(:resource) do
    AmazonSellingPartners::ListingsItem.new(seller_id: 'ASELLER', sku: '697821896',
                                            marketplace_id: 'A2VIGQ35RCS4UG')
  end
  let(:item_url) do
    'https://sellingpartnerapi-eu.amazon.com/listings/2021-08-01/items/ASELLER/697821896'
  end

  before do
    stub_request(:post, 'https://api.amazon.com/auth/o2/token')
      .to_return(status: 200, body: { access_token: 'Atza|token', expires_in: 3600 }.to_json)
  end

  it 'deletes the listing for the SKU' do
    request = stub_request(:delete, item_url)
              .with(query: { marketplaceIds: 'A2VIGQ35RCS4UG' })
              .to_return(status: 200, body: { sku: '697821896', status: 'ACCEPTED',
                                              submissionId: 'del-1', issues: [] }.to_json)

    operation.perform

    expect(request).to have_been_requested
    expect(operation.result.resource).to have_attributes(status: 'ACCEPTED', submission_id: 'del-1')
  end

  it 'fails with NotFound for a SKU the seller does not have' do
    stub_request(:delete, item_url).with(query: hash_including({})).to_return(status: 404, body: '{}')

    operation.perform

    expect(operation.result.error).to be_a(AmazonSellingPartners::Errors::NotFound)
  end
end

# rubocop:enable Metrics/BlockLength
