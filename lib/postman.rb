require 'bundler/setup'
require 'fallen'
require 'fallen/cli'
require 'data_mapper'

require_relative 'postman/config'
require_relative 'postman/adapter'
require_relative 'postman/loader'

module Postman
  extend Fallen
  extend Fallen::CLI

  @@normal_sleep = 0
  @@low_sleep = 0

  def self.find_and_deliver
    emails = []

    #Urgent emails
    emails.concat Postman.find_emails(:urgent, Postman.configuration.urgent_quota)

    if(@@normal_sleep == Postman.configuration.normal_sleep)
      emails.concat Postman.find_emails(:normal, Postman.configuration.normal_quota)
      @@normal_sleep = 0
    else
      @@normal_sleep += 1
    end

    if(@@low_sleep == Postman.configuration.low_sleep)
      emails.concat Postman.find_emails(:low, Postman.configuration.low_quota)
      @@low_sleep = 0
    else
      @@low_sleep += 1
    end

    Postman.send_emails(emails)
  end

  def self.run
    while running?
      Postman.find_and_deliver
      sleep Postman.configuration.sleep
    end
  end
end

case Clap.run(ARGV, Postman.cli).first

when "start"
  Postman.start!
when "stop"
  Postman.stop!
when "usage", "help"
  puts Postman.fallen_usage
end

