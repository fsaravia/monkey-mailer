root = ::File.dirname(__FILE__)
require ::File.join(root,'..', 'lib', 'monkey-mailer')

require 'database_cleaner'

MonkeyMailer.configure do |config|
  config.databases = {
    'default' => {
      :adapter => 'mysql',
      :user => 'monkey-mailer',
      :password => 'monkey_mailer_dev',
      :database => 'monkey_mailer_test'
    }
  }
end
Dir[::File.join(root, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.order = "random"

  config.before(:suite) do
    MonkeyMailer.loader
    DatabaseCleaner.strategy = :transaction
    DataMapper.auto_upgrade!
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end