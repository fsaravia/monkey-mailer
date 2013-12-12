require 'monkey-mailer/adapters/dummy'
require 'monkey-mailer/adapters/mandrilapi'
require 'monkey-mailer/adapters/smtp'

module MonkeyMailer

  def self.adapter
    @@adapter ||= register_adapter
  end

  def self.reset_adapter
    @@adapter = nil
  end

  def self.deliver(email)
    adapter.send_email(email)
  end

  def self.send_emails(emails)
    emails.each do |email|
      begin
        deliver(email)
        delete_email(email)
      rescue DeliverError => e
        puts e.message
        puts e.backtrace
      end
    end
  end

  private
  def self.register_adapter
    @@adapter = MonkeyMailer.configuration.adapter.new(MonkeyMailer.configuration.adapter_options)
  end
end