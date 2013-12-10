root = ::File.dirname(__FILE__)
require ::File.join(root,'..', 'lib', 'monkey-mailer')

Dir[::File.join(root, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.order = "random"

  config.before(:suite) do
    MonkeyMailer.loader
  end
end