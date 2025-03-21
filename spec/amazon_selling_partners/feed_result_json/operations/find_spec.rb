require 'spec_helper'
require 'amazon_selling_partners/feed_result_json/operations/find'

RSpec.describe AmazonSellingPartners::FeedResultJson::Operation::Find do
  let(:client) { build(:client) }
  let(:feed_result) { build(:feed_result) }

  subject(:operation) { described_class.new(client: client, resource: feed_result) }

  before do
    stub_request(:post, "https://api.amazon.com/auth/o2/token").to_return(
      status: 200, body: {"access_token":"Atza|IwEBIGHsPhjJfzoiDu7v01JSwPyTK4cbMHn0HRjrFH8bzIZVXagyeAwMoRd9dKmTzm5i6aJ2Fm2PpXarnmq-P8S0LNImAFwnmegDNCh-on6ASozBvNnHQ-3pTKunhCTE1l6rPOkYl7XUHEuQEarsqzjE9BIsuSG6rd7zbQzZKnI5FTxakkeB38WLrWTHaIQZiugOwJh_FePG2utTKPgaBoNB_HIW0fAEdeI_8AUXEEOa2HhWVZK-Dn2-zcbeocGbntpPYPn3us3nDQhYjyUu8jlRBIbGe9G1P2a0eFF2BZfCg4afvXfebZv6z6l3GVlY35AGZmzI1mNn7Fw4_kC17659CI3_AHuoLMWLwo7bVafouTuAzw","refresh_token":"Atzr|IwEBIAi3FI9hlmQmrZMhZTC4tleVTgtt3l-CJ1940zbMKPic1L6orpTXHJpD61Gtcxe23JtM4TYhdcSvr2X3d7iC_Ub-4BwJqzDwG7Nfm2wCO1IMri6XPIoQ1VSxVbJ3Cpe2XK4yMtq-6VaLmlxVitW_J3Yx-Hl-3oHKpphTJ75Tp1804ERk3SffqgnU3VwQsoyV5yJbX6OuVKgE58dQu-lJW_As9a7N9BClMTkzC9Q8B7a2NNDQMTlyZ4TY-BgPvXONZNst_sRpZmg1K2lj0Nex9ce9A7QP9Aij_Zrl9lKxBwrGILc4ledZ30E-9vFsZgLFLoRLIbgV4MriSgs6zTjI-lmS","token_type":"bearer","expires_in":3600}.to_json, headers: {}
    )
  end

  context '#perform' do
    let(:response_body) { "\x1F\x8B\b\x00\x00\x00\x00\x00\x00\xFF\xCD\x98\xCDj\xC30\f\xC7_%\xE8\xD2\x8B)v\x92\xC6\x89o=\x94\xAD\xD0\xAD\xA3\x8C\r6\xC6p\x13\xA55\xE4\xA3XIF)}\xF7\x91\x96}\xB1\x17\x90\x8F\xB2e~\x96\xAC\xBF\x8CO\xB0G[\xA0\as\x02\xC2\xAAB\xBF,\xC0\xC0\\\xC9\xDB\xA7\xC5j\xF5\xBC\xBE\xD1/w `@O\xAEm\xC0@8\x95 \xA0D,.+\xC3H\xC7Q,C\xA9\x12\rg\x01\x8E\xA8G\x02\xF3z\x82\x1A\x89\xEC\x0E\xC7e\xA1\x80\xBC-\x10\f\xC4r\x1C\n\x04\x10\x0E\xE8]w\x04\x03\x8B\xCDf\xBD\x01\xF1\xE5\x01\x06\x1E\xF7\x18\x1C|;\xB8\x02\x8B`\xB0U\x8FA\xD9\xFA`r\xE8}\xBE\xB7d\xB7\x15\xBE\xB7e\x89~\x128\n\\3\xD8\xCA\x15S\x10`\xBB\xCE\xBBm\xDF\xE1\xBD\xAD\xC7\x8D\xFE9\xC0Y\xFCA\x9B\xA5\x9A/\\\xA2\x18G.\t3\xCEp)c8\xCD9\xAD:f\f\xC7\xBAZS\xC6\x05\xA1\xC3\x843\x1C\xE7\xC8E\x8A3\x1Cc)I\x15c)I\xE3\x881\\\xCA\xF8\xCEe\x8A\xB1\x94d\x9C\xD3\x9A\xCD\x18\xEB\\\x961~2)\xA9\x18w~%970%97\t%c\xC6Z\xA7\xE4\x8Cq\x0FS\x92u\xCD*\xC9\x8A\xEEM\x00\xF5um\xFDq\xFC\xEE@\xEF[O`B-\xE0\xC3\xFA\xC65;\x02#\xBFa\xE8\xC1\xB79\x12\xE1\xE5$\xD1\xAF\x89y\x9E\xE3\xA1\xBB\xDAe\xF4c_^i\xC6-\xCF\xE7O=\n\xB0\xA6Z\x11\x00\x00" }

    before do
      stub_request(:get, feed_result.url).to_return(status: 200, body: response_body, headers: {})
    end

    it 'returns success result' do
      operation.perform

      expect(operation.success?).to be true
      expect(operation.result.resource.processed).to eq 1130
      expect(operation.result.resource.successful).to eq 1103
      expect(operation.result.resource.ledger_errors.count).to eq 27
    end
  end
end
