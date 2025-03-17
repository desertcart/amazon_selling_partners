# frozen_string_literal: true

FactoryBot.define do
  factory :feed_document, class: 'AmazonSellingPartners::FeedDocument' do
    url { "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/420b339b-358a-4506-b7b9-0f0f697d281f.amzn1.tortuga.4.eu.T1A64R32N6TLNS?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250310T141633Z&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Expires=300&X-Amz-Credential=AKIAX2ZVOZFBAKZHPSBJ%2F20250310%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Signature=135224a7cf555e284aee6217b884a32d831e9534db39fb42ef82eb31b8a44c95" }
    feed_document_id { "amzn1.tortuga.4.eu.420b339b-358a-4506-b7b9-0f0f697d281f.T1A64R32N6TLNS" }
    content_attributes { %i[sku quantity price maximum_seller_allowed_price minimum_seller_allowed_price handling_time] }
    seller_id { 'A10LE8TF2RTIHL' }
    feed_contents { [association(:feed_content)] }
  end
end
