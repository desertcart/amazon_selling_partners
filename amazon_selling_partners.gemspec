# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'amazon_selling_partners'
  spec.version       = '0.3.0'
  spec.authors       = ['Kostas Kostoglou']
  spec.email         = ['kostas@dropbot.sh']

  spec.summary       = 'Communicate with Amazon Selling Partners API'
  spec.description   = 'Communicate with Amazon Selling Partners API'
  spec.homepage      = 'https://dropbot.sh/'
  spec.required_ruby_version = '>= 3.1.0'

  spec.add_runtime_dependency 'aws-sigv4'
  spec.add_runtime_dependency 'json', '>= 1.8'
  spec.add_runtime_dependency 'ledger_sync'
  spec.add_runtime_dependency 'typhoeus', '~> 1.0', '>= 1.0.1'

  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'factory_bot'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/sandbite/dropbot'
  spec.metadata['changelog_uri'] = 'https://github.com/sandbite/dropbot'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency 'example-gem', '~> 1.0'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
