# frozen_string_literal: true

FactoryBot.define do
  factory :feed_content, class: 'AmazonSellingPartners::FeedContent' do
    id { 123 }
    sku { 50611000 }
    quantity { 2 }
    handling_time { 3 }
    price { '307.05' }
    minimum_seller_allowed_price { price }
    maximum_seller_allowed_price { price }
  end
end
