require 'fallen'
require 'fallen/cli'
require 'data_mapper'

require_relative 'postman/config'
require_relative 'postman/database'
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
      mails.concat Postman.find_mails(MailUrgent, Postman.settings['urgent_quota'])

      @@normal_sleep += 1
      @@low_sleep += 1

      if(@@normal_sleep == Postman.settings['normal_sleep'])
        mails.concat Postman.find_mails(MailNormal, Postman.settings['normal_quota'])
        @@normal_sleep = 0
      end

      if(@@low_sleep == Postman.settings['low_sleep'])
        mails.concat Postman.find_mails(MailLow, Postman.settings['low_quota'])
        @@low_sleep = 0
      end

      Postman.send_mails(mails)
      sleep Postman.settings['sleep']
    end
  end
end

case Clap.run(ARGV, Postman.cli).first

when "start"
  Postman.start!
when "stop"
  Postman.stop!
else
  Postman.fallen_usage
end

