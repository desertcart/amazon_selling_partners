# frozen_string_literal: true

module AmazonSellingPartners
  def self.root(*paths)
    File.join(File.expand_path('../..', __dir__), *paths.map(&:to_s))
  end
end

require 'amazon_selling_partners/config'
