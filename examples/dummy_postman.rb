require 'monkey-mailer'

module DummyPostman
  extend MonkeyMailer
  extend Fallen::CLI

  MonkeyMailer.configure do |config|
      config.sleep = 2
      config.adapter = MonkeyMailer::Adapters::Dummy
      config.loader = MonkeyMailer::Loaders::Dummy
      config.urgent_quota = 1
      config.normal_quota = 1
      config.low_quota = 1
  end
end

case Clap.run(ARGV, DummyPostman.cli).first

when "start"
  DummyPostman.start!
when "stop"
  DummyPostman.stop!
when "usage", "help"
  puts DummyPostman.fallen_usage
end