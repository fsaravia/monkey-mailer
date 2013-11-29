require 'fallen'
require 'fallen/cli'
require 'data_mapper'

require_relative 'postman/config'
require_relative 'postman/database'

module Postman
  extend Fallen
  extend Fallen::CLI

  URGENT_QUOTA = 100
  NORMAL_QUOTA = 100
  LOW_QUOTA = 100

  @@normal_sleep = 0
  @@low_sleep = 0

  def self.run
    while running?

      mails = []

      #Urgent mails
      mails.concat Postman.find_mails(MailUrgent, Postman.settings['urgent_quota'])

      @@normal_sleep += 1
      @@low_sleep += 1

      if(@@normal_sleep == 12)
        mails.concat Postman.find_mails(MailNormal, Postman.settings['normal_quota'])
        @@normal_sleep = 0
      end

      if(@@low_sleep == 54)
        mails.concat Postman.find_mails(MailLow, Postman.settings['low_quota'])
        @@low_sleep = 0
      end

      send_mails(mails)
      sleep 5
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

  def self.send_mails(mails)
    mails.each do |mail|
      begin
        deliver(mail)
        mail.destroy
      rescue DeliverError => e
        puts e.message
        puts e.backtrace
      end
    end
  end
end

case Postman.settings['adapter']
when 'mandrilapi'
  require_relative 'postman/adapters/mandrilapi'
  adapter = Postman::MandrilAPI.new(Postman.settings['mandril_api_key'])
when 'smtp'
  require_relative 'postman/adapters/smtp'
  adapter = Postman::Smtp.new(Postman.settings['smtp'])
when 'dummy'
  require_relative 'postman/adapters/dummy'
  adapter = Postman::Dummy.new
else
  raise "Adapter #{Postman.settings['adapter']} does not exist"
end

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

