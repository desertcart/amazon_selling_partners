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

An offer-only listing: your SKU on an ASIN that is already in the catalog. Check
restrictions first, make sure the SKU doesn't exist yet (`putListingsItem` replaces a
listing's content), and use `VALIDATION_PREVIEW` to validate without saving anything.

```ruby
marketplace_id = 'A2VIGQ35RCS4UG' # UAE marketplace

restrictions = AmazonSellingPartners::ListingsRestrictions::Operation::Find.new(
  client: client,
  resource: AmazonSellingPartners::ListingsRestrictions.new(
    asin: 'B0DNDS8C2X', seller_id: 'A1B2C3D4E5F6G7', marketplace_id: marketplace_id
  )
)
restrictions.perform
restrictions.result.resource.restrictions # => [] when the seller can list it

existing = AmazonSellingPartners::ListingsItem::Operation::Find.new(
  client: client,
  resource: AmazonSellingPartners::ListingsItem.new(
    seller_id: 'A1B2C3D4E5F6G7', sku: 'MY-SKU', marketplace_id: marketplace_id
  )
)
existing.perform
existing.result.error # => AmazonSellingPartners::Errors::NotFound when the SKU is free

listing = AmazonSellingPartners::ListingsItem.new(
  seller_id: 'A1B2C3D4E5F6G7', sku: 'MY-SKU', marketplace_id: marketplace_id,
  product_type: 'PRODUCT', requirements: 'LISTING_OFFER_ONLY',
  mode: AmazonSellingPartners::ListingsItem::VALIDATION_PREVIEW, # drop to submit for real
  listing_attributes: {
    merchant_suggested_asin: [{ value: 'B0DNDS8C2X', marketplace_id: marketplace_id }],
    condition_type: [{ value: 'new_new', marketplace_id: marketplace_id }],
    purchasable_offer: [{ currency: 'AED', marketplace_id: marketplace_id,
                          our_price: [{ schedule: [{ value_with_tax: 89.0 }] }] }],
    fulfillment_availability: [{ fulfillment_channel_code: 'DEFAULT', quantity: 10,
                                 lead_time_to_ship_max_days: 2 }]
  }
)
operation = AmazonSellingPartners::ListingsItem::Operation::Put.new(client: client, resource: listing)
operation.perform
operation.result.resource.status # => "VALID" (preview), "ACCEPTED" or "INVALID"
operation.result.resource.issues # => [{ "code" => ..., "message" => ..., "severity" => "ERROR" }, ...]

# Remove it again
delete = AmazonSellingPartners::ListingsItem::Operation::Delete.new(
  client: client,
  resource: AmazonSellingPartners::ListingsItem.new(
    seller_id: 'A1B2C3D4E5F6G7', sku: 'MY-SKU', marketplace_id: marketplace_id
  )
)
delete.perform
delete.result.resource.status # => "ACCEPTED"
```

### Example of fetching offers for a product by ASIN
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

resource = AmazonSellingPartners::ProductPricing.new(market_place_id: 'A2VIGQ35RCS4UG', asin: 'B07F2GC4S9')
operation = AmazonSellingPartners::ProductPricing::Operation::Find.new(client: client, resource: resource)
operation.perform
```

### Example of fetching offers for up to 20 ASINs at once (getItemOffersBatch)
Keyed by ASIN, so it also works for items you don't list. Each item comes back as a
`ProductPricing` with `status_code`, `offers`, `total_offer_count`, and `error_code` /
`error_message` when that ASIN failed (for example an ASIN that doesn't exist in the marketplace).
```ruby
resource = AmazonSellingPartners::ItemOffersBatch.new(
  market_place_id: 'A2VIGQ35RCS4UG',
  asins: %w[B07F2GC4S9 B0DTKCN3Z4] # 1..20 ASINs
)
operation = AmazonSellingPartners::ItemOffersBatch::Operation::Find.new(client: client, resource: resource)
operation.perform

if operation.success?
  operation.result.resource.items.each do |item|
    next unless item.status_code == 200

    item.offers.each { |offer| puts [item.asin, offer.seller_id, offer.price, offer.is_prime].inspect }
  end
else
  # AmazonSellingPartners::Errors::Unauthorized (401/403 or a rejected refresh token),
  # ::Throttled (429), ::ServerError (5xx, timeouts) or ::RequestError
  operation.result.error
end
```
