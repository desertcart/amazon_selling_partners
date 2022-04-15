# frozen_string_literal: true

opts = {
  base_module: AmazonSellingPartners,
  root_path: 'amazon_selling_partners'
}

LedgerSync.register_ledger(:amazon_selling_partners, opts) do |config|
  config.name = 'AmazonSellingPartners'
end
