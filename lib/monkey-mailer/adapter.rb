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

  def self.send_emails(emails)
    emails.each do |email|
      begin
        adapter.send_email(email)
        loader.delete_email(email)
      rescue DeliverError => e
        puts e.message
        puts e.backtrace
      end
    end
  end

  class DeliverError < StandardError; end

  private
  def self.register_adapter
    @@adapter = MonkeyMailer.configuration.adapter.new(MonkeyMailer.configuration.adapter_options)
  end
end
