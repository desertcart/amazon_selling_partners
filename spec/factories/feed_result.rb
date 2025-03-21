# frozen_string_literal: true

FactoryBot.define do
  factory :feed_result, class: 'AmazonSellingPartners::FeedResultJson' do
    url { "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/8fca0d05-82df-4d2f-b750-ec37d1071eda.amzn1.tortuga.4.eu.T1EBEWZG1J8KL7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20250320T163340Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=AKIAX2ZVOZFBAKZHPSBJ%2F20250320%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Signature=3ded218640b5af1c28ff3b48f89268f144527edbbb9351b44bf78d937cf6825d" }
    processed { 0 }
    successful { 0 }
    ledger_errors { [] }
  end
end