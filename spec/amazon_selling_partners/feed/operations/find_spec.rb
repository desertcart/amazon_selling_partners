require 'spec_helper'
require 'amazon_selling_partners/feed/operations/find'

RSpec.describe AmazonSellingPartners::Feed::Operation::Find do
  let(:client) { build(:client) }
  let(:feed) { build(:feed, feed_id: '582270020158', result_feed_document_id: nil) }

  subject(:operation) { described_class.new(client: client, resource: feed) }

  before do
    stub_request(:post, "https://api.amazon.com/auth/o2/token").to_return(
      status: 200, body: {"access_token":"Atza|IwEBIGHsPhjJfzoiDu7v01JSwPyTK4cbMHn0HRjrFH8bzIZVXagyeAwMoRd9dKmTzm5i6aJ2Fm2PpXarnmq-P8S0LNImAFwnmegDNCh-on6ASozBvNnHQ-3pTKunhCTE1l6rPOkYl7XUHEuQEarsqzjE9BIsuSG6rd7zbQzZKnI5FTxakkeB38WLrWTHaIQZiugOwJh_FePG2utTKPgaBoNB_HIW0fAEdeI_8AUXEEOa2HhWVZK-Dn2-zcbeocGbntpPYPn3us3nDQhYjyUu8jlRBIbGe9G1P2a0eFF2BZfCg4afvXfebZv6z6l3GVlY35AGZmzI1mNn7Fw4_kC17659CI3_AHuoLMWLwo7bVafouTuAzw","refresh_token":"Atzr|IwEBIAi3FI9hlmQmrZMhZTC4tleVTgtt3l-CJ1940zbMKPic1L6orpTXHJpD61Gtcxe23JtM4TYhdcSvr2X3d7iC_Ub-4BwJqzDwG7Nfm2wCO1IMri6XPIoQ1VSxVbJ3Cpe2XK4yMtq-6VaLmlxVitW_J3Yx-Hl-3oHKpphTJ75Tp1804ERk3SffqgnU3VwQsoyV5yJbX6OuVKgE58dQu-lJW_As9a7N9BClMTkzC9Q8B7a2NNDQMTlyZ4TY-BgPvXONZNst_sRpZmg1K2lj0Nex9ce9A7QP9Aij_Zrl9lKxBwrGILc4ledZ30E-9vFsZgLFLoRLIbgV4MriSgs6zTjI-lmS","token_type":"bearer","expires_in":3600}.to_json, headers: {}
    )
  end

  context '#perform' do
    before do
      stub_request(:get, "https://sellingpartnerapi-eu.amazon.com/feeds/2021-06-30/feeds/582270020158")
        .to_return(
          status: 200,
          body: {
            "processingEndTime"=>"2025-03-11T12:00:41+00:00",
            "processingStatus"=>"DONE",
            "marketplaceIds"=>["A2VIGQ35RCS4UG"],
            "feedId"=>"582270020158",
            "feedType"=>"JSON_LISTINGS_FEED",
            "createdTime"=>"2025-03-11T11:58:51+00:00",
            "processingStartTime"=>"2025-03-11T12:00:32+00:00",
            "resultFeedDocumentId"=>"amzn1.tortuga.4.eu.67436458-5f75-4e89-a8a3-330a8f058364.TKQ6INPA6L7CP"
          }.to_json,
          headers: {}
        )
    end

    it 'returns success result' do
      operation.perform

      expect(operation.success?).to be true
      expect(operation.result.resource.result_feed_document_id).to eq "amzn1.tortuga.4.eu.67436458-5f75-4e89-a8a3-330a8f058364.TKQ6INPA6L7CP"
    end
  end
end
