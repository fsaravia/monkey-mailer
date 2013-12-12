require 'monkey-mailer'

Dir[::File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.order = "random"

  config.before(:suite) do
    MonkeyMailer.loader
  end
end