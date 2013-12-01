root = ::File.dirname(__FILE__)
require ::File.join(root,'..', 'postman')

require 'database_cleaner'

Postman.configure do |config|
  config.databases = {
    'default' => {
      :adapter => 'mysql',
      :user => 'root',
      :password => 'sapito',
      :database => 'postman_test'
    }
  }
end
require_relative '../postman/database'
require_relative 'support/test_adapter'
require_relative 'support/spawners'

RSpec.configure do |config|

  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end