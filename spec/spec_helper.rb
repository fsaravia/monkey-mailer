root = ::File.dirname(__FILE__)
require ::File.join(root,'..', 'lib', 'postman')

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
Dir[::File.join(root, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.order = "random"

  config.before(:suite) do
    Postman.loader
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