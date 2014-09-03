require 'fallen'
require 'fallen/cli'
require 'yaml'
require 'monkey-mailer/email'
require 'monkey-mailer/adapter'
require 'monkey-mailer/loader'
require 'monkey-mailer/config'

module MonkeyMailer
  extend Fallen

  def self.extended(base)
    base.extend(Fallen)
  end

  @@normal_sleep = 0
  @@low_sleep = 0

  def self.find_and_deliver
    emails = []

    #Urgent emails
    emails.concat loader.find_emails(:urgent, MonkeyMailer.configuration.urgent_quota)

    if(@@normal_sleep == configuration.normal_sleep)
      emails.concat loader.find_emails(:normal, MonkeyMailer.configuration.normal_quota)
      @@normal_sleep = 0
    else
      @@normal_sleep += 1
    end

    if(@@low_sleep == configuration.low_sleep)
      emails.concat loader.find_emails(:low, MonkeyMailer.configuration.low_quota)
      @@low_sleep = 0
    else
      @@low_sleep += 1
    end

    send_emails(emails)
  end

  def run
    while running?
      MonkeyMailer.find_and_deliver
      sleep MonkeyMailer.configuration.sleep
    end
  end
end
