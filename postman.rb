require 'fallen'
require 'fallen/cli'
require 'data_mapper'

require_relative 'config'
require_relative 'database'
require_relative 'adapters/smtp'
require_relative 'adapters/mandrilapi'

module Postman
  extend Fallen
  extend Fallen::CLI

  def self.run
    while running?
      mails = MailQueue.first
      puts "Sending: #{mails.inspect}"
      Postman.deliver(mails)
      sleep 10
    end
  end

  def self.usage
    puts fallen_usage
  end

  def self.set_adapter(adapter)
    @@adapter = adapter
  end

  def self.deliver(email)
    if !@@adapter.nil?
      @@adapter.send_mail(email)
    else
      puts 'No adapter' #refactor this
    end
  end
end

smtp = Smtp.new({
  :address              => 'smtp.mandrillapp.com',
  :port                 => 587,
  :domain               => 'example.com',
  :user_name            => 'user@example.com',
  :password             => 'example-password',
  :authentication       => 'plain',
  :enable_starttls_auto => true
});

mandrilapi = MandrilAPI.new("example-password")

Postman.set_adapter(mandrilapi)

case Clap.run(ARGV, Postman.cli).first

when "start"
  Postman.start!
when "stop"
  Postman.stop!
else
  Postman.usage
end

