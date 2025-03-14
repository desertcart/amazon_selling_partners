# frozen_string_literal: true

FactoryBot.define do
  factory :feed, class: 'AmazonSellingPartners::Feed' do
    sequence(:feed_id) { "582270020158" }
    sequence(:result_feed_document_id) { "amzn1.tortuga.4.eu.67436458-5f75-4e89-a8a3-330a8f058364.TKQ6INPA6L7CP" }
    market_place_id { 'A2VIGQ35RCS4UG' }
    feed_type { 'JSON_LISTINGS_FEED' }
    association :feed_document
  end
end
