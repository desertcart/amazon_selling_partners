# AmazonSellingPartners

A gem to interact with Amazon Selling Partner API using Ledgersync operations.
Not for the faint hearted!

Currently considered a WIP

## Installation

Currently not published. Just do a regular `bundle install`

## Usage

To start you need to have your amazon credentials handy, along with a way to store and retrieve your access token (to avoid issuing a new one on each request).


### Example of updating a product listing
```ruby
client = AmazonSellingPartners::Client.new(
  sandbox: false,
  debug: false,
  # eu region also covers UAE and SA
  region: 'eu',
  refresh_token: ENV['AMAZON_SELLING_PARTNERS_API_REFRESH_TOKEN'],
  client_id: ENV['AMAZON_SELLING_PARTNERS_API_CLIENT_ID'],
  client_secret: ENV['AMAZON_SELLING_PARTNERS_API_CLIENT_SECRET'],
  aws_access_key_id: ENV['AMAZON_SELLING_PARTNERS_API_AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AMAZON_SELLING_PARTNERS_API_AWS_SECRET_ACCESS_KEY'],
  # if you skip setting the following lambdas, the client will request a new token before each API call
  get_access_token: ->(access_token_key) { Rails.cache.read("AMAZON_SELLING_PARTNERS_API_TOKEN-#{access_token_key}") },
  save_access_token: ->(access_token_key, token) { Rails.cache.write(
    "AMAZON_SELLING_PARTNERS_API_TOKEN-#{access_token_key}",
    token[:access_token],
    expires_in: token[:expires_in] - 60
  ) }
)

feed_content_resource = AmazonSellingPartners::FeedContent.new(
  sku: 123,
  price: '9999',
  minimum_seller_allowed_price: '9999',
  maximum_seller_allowed_price: '9999',
  quantity: 1,
  handling_time: 3
)
content_attributes = %i[sku quantity price maximum_seller_allowed_price minimum_seller_allowed_price handling_time]
feed_document_resource = AmazonSellingPartners::FeedDocument.new(feed_contents: [feed_content_resource], content_attributes:)
operation = AmazonSellingPartners::FeedDocument::Operation::Create.new(client: client, resource: feed_document_resource)
operation.perform

feed_update_op = AmazonSellingPartners::FeedDocument::Operation::Update.new(client: client, resource: operation.result.resource)
feed_update_op.perform
feed = AmazonSellingPartners::Feed.new(
  feed_document: operation.result.resource,
  feed_type: 'POST_FLAT_FILE_PRICEANDQUANTITYONLY_UPDATE_DATA',
  market_place_id: 'A2VIGQ35RCS4UG' # UAE marketplace
)

feed_operation = AmazonSellingPartners::Feed::Operation::Create.new(client: client, resource: feed)
feed_operation.perform

result_feed_document_id = nil
# Amazon takes some time to process the feed we submitted. This is a synchronous way to poll for the result
12.times do
   feed_find_operation = AmazonSellingPartners::Feed::Operation::Find.new(client: client, resource: feed_operation.result.resource)
   feed_find_operation.perform
   if feed_find_operation.success? && feed_find_operation.result.resource.result_feed_document_id.present?
      result_feed_document_id = feed_find_operation.result.resource.result_feed_document_id
      break
   end
   sleep 10
end

# Lets get the result document
result_doc_op = AmazonSellingPartners::FeedDocument::Operation::Find.new(
  client: client,
  resource: AmazonSellingPartners::FeedDocument.new(feed_document_id: result_feed_document_id)
)
result_doc_op.perform

# Let's fetch it and parse it
feed_result = AmazonSellingPartners::FeedResult.new(url: result_doc_op.result.resource.url)
result_op = AmazonSellingPartners::FeedResult::Operation::Find.new(client:, resource: feed_result)
result_op.perform
```

### Example of creating a listing for an existing product (existing ASIN)
```ruby
client = AmazonSellingPartners::Client.new(
  sandbox: false,
  debug: false,
  # eu region also covers UAE and SA
  region: 'eu',
  refresh_token: ENV['AMAZON_SELLING_PARTNERS_API_REFRESH_TOKEN'],
  client_id: ENV['AMAZON_SELLING_PARTNERS_API_CLIENT_ID'],
  client_secret: ENV['AMAZON_SELLING_PARTNERS_API_CLIENT_SECRET'],
  aws_access_key_id: ENV['AMAZON_SELLING_PARTNERS_API_AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AMAZON_SELLING_PARTNERS_API_AWS_SECRET_ACCESS_KEY'],
  # if you skip setting the following lambdas, the client will request a new token before each API call
  get_access_token: ->(access_token_key) { Rails.cache.read("AMAZON_SELLING_PARTNERS_API_TOKEN-#{access_token_key}") },
  save_access_token: ->(access_token_key, token) { Rails.cache.write(
    "AMAZON_SELLING_PARTNERS_API_TOKEN-#{access_token_key}",
    token[:access_token],
    expires_in: token[:expires_in] - 60
  ) }
)

feed_content_resource = AmazonSellingPartners::FeedContent.new(
  sku: 123,
  price: '9999',
  minimum_seller_allowed_price: '9999',
  maximum_seller_allowed_price: '9999',
  quantity: 1,
  handling_time: 3,
  product_id: 'B08VJCGK7H',
  product_id_type: 1,
  item_condition: 11
)
content_attributes = %i[sku quantity price handling_time maximum_seller_allowed_price minimum_seller_allowed_price product_id product_type]
feed_document_resource = AmazonSellingPartners::FeedDocument.new(feed_contents: [feed_content_resource], content_attributes:)
operation = AmazonSellingPartners::FeedDocument::Operation::Create.new(client: client, resource: feed_document_resource)
operation.perform

feed_update_op = AmazonSellingPartners::FeedDocument::Operation::Update.new(client: client, resource: operation.result.resource)
feed_update_op.perform
feed = AmazonSellingPartners::Feed.new(
  feed_document: operation.result.resource,
  feed_type: 'POST_FLAT_FILE_INVLOADER_DATA',
  market_place_id: 'A2VIGQ35RCS4UG' # UAE marketplace
)

feed_operation = AmazonSellingPartners::Feed::Operation::Create.new(client: client, resource: feed)
feed_operation.perform

result_feed_document_id = nil
# Amazon takes some time to process the feed we submitted. This is a synchronous way to poll for the result
12.times do
  feed_find_operation = AmazonSellingPartners::Feed::Operation::Find.new(client: client, resource: feed_operation.result.resource)
  feed_find_operation.perform
  if feed_find_operation.success? && feed_find_operation.result.resource.result_feed_document_id.present?
    result_feed_document_id = feed_find_operation.result.resource.result_feed_document_id
    break
  end
  sleep 10
end

# Lets get the result document
result_doc_op = AmazonSellingPartners::FeedDocument::Operation::Find.new(
  client: client,
  resource: AmazonSellingPartners::FeedDocument.new(feed_document_id: result_feed_document_id)
)
result_doc_op.perform

# Let's fetch it and parse it
feed_result = AmazonSellingPartners::FeedResult.new(url: result_doc_op.result.resource.url)
result_op = AmazonSellingPartners::FeedResult::Operation::Find.new(client:, resource: feed_result)
result_op.perform
```