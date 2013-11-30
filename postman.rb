require 'bundler/setup'
require 'fallen'
require 'fallen/cli'
require 'dm-core'

require_relative 'postman/config'
require_relative 'postman/adapter'

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
      mails.concat Postman.find_mails(MailUrgent, Postman.configuration.urgent_quota)

      @@normal_sleep += 1
      @@low_sleep += 1

      if(@@normal_sleep == Postman.configuration.normal_sleep)
        mails.concat Postman.find_mails(MailNormal, Postman.configuration.normal_quota)
        @@normal_sleep = 0
      end

      if(@@low_sleep == Postman.configuration.low_sleep)
        mails.concat Postman.find_mails(MailLow, Postman.configuration.low_quota)
        @@low_sleep = 0
      end

      Postman.send_mails(mails)
      sleep Postman.configuration.sleep
    end
  end
end

case Clap.run(ARGV, Postman.cli).first

when "start"
  require_relative 'postman/database'
  Postman.start!
when "stop"
  Postman.stop!
when "usage", "help"
  puts Postman.fallen_usage
end

