require 'spec_helper'
require 'amazon_selling_partners/feed_document/operations/update_json'

RSpec.describe AmazonSellingPartners::FeedDocument::Operation::UpdateJson do
  let(:client) { build(:client) }
  let(:feed_content) { build(:feed_content) }
  let(:feed_document) { build(:feed_document, feed_contents: [feed_content]) }

  subject(:operation) { described_class.new(client: client, resource: feed_document) }

  before do
    stub_request(:post, "https://api.amazon.com/auth/o2/token").to_return(
      status: 200, body: {"access_token":"Atza|IwEBIGHsPhjJfzoiDu7v01JSwPyTK4cbMHn0HRjrFH8bzIZVXagyeAwMoRd9dKmTzm5i6aJ2Fm2PpXarnmq-P8S0LNImAFwnmegDNCh-on6ASozBvNnHQ-3pTKunhCTE1l6rPOkYl7XUHEuQEarsqzjE9BIsuSG6rd7zbQzZKnI5FTxakkeB38WLrWTHaIQZiugOwJh_FePG2utTKPgaBoNB_HIW0fAEdeI_8AUXEEOa2HhWVZK-Dn2-zcbeocGbntpPYPn3us3nDQhYjyUu8jlRBIbGe9G1P2a0eFF2BZfCg4afvXfebZv6z6l3GVlY35AGZmzI1mNn7Fw4_kC17659CI3_AHuoLMWLwo7bVafouTuAzw","refresh_token":"Atzr|IwEBIAi3FI9hlmQmrZMhZTC4tleVTgtt3l-CJ1940zbMKPic1L6orpTXHJpD61Gtcxe23JtM4TYhdcSvr2X3d7iC_Ub-4BwJqzDwG7Nfm2wCO1IMri6XPIoQ1VSxVbJ3Cpe2XK4yMtq-6VaLmlxVitW_J3Yx-Hl-3oHKpphTJ75Tp1804ERk3SffqgnU3VwQsoyV5yJbX6OuVKgE58dQu-lJW_As9a7N9BClMTkzC9Q8B7a2NNDQMTlyZ4TY-BgPvXONZNst_sRpZmg1K2lj0Nex9ce9A7QP9Aij_Zrl9lKxBwrGILc4ledZ30E-9vFsZgLFLoRLIbgV4MriSgs6zTjI-lmS","token_type":"bearer","expires_in":3600}.to_json, headers: {}
    )
  end

  context "#perform" do
    context "with successful response" do
      before do
        stub_request(:put, feed_document.url).
          with(
            body: "{\"header\":{\"sellerId\":\"A10LE8TF2RTIHL\",\"version\":\"2.0\"},\"messages\":[{\"messageId\":1,\"sku\":\"50611000\",\"operationType\":\"PARTIAL_UPDATE\",\"productType\":\"PRODUCT\",\"attributes\":{\"fulfillment_availability\":[{\"fulfillment_channel_code\":\"DEFAULT\",\"quantity\":2,\"lead_time_to_ship_max_days\":3}],\"purchasable_offer\":[{\"our_price\":[{\"schedule\":[{\"value_with_tax\":\"307.05\"}]}],\"maximum_seller_allowed_price\":[{\"schedule\":[{\"value_with_tax\":\"307.05\"}]}],\"minimum_seller_allowed_price\":[{\"schedule\":[{\"value_with_tax\":\"307.05\"}]}]}]}}]}",
            headers: { 'Content-Type'=>'application/json' }
          ).to_return(status: 200, body: "", headers: {})
      end

      it 'returns successful result' do
        operation.perform

        expect(operation.success?).to be true
     end
    end

    context "with fail response" do
      before do
        stub_request(:put, feed_document.url).to_return(status: [403, "Forbidden"], body: "", headers: {})
      end

      it "returns fail result" do
        operation.perform

        expect(operation.success?).to be false
        expect(operation.result.error).to eq "AmazonSellingPartners api request failed: 403 Forbidden"
      end
    end
  end
end
