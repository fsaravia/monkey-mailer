require 'monkey-mailer/loaders/dummy'

module MonkeyMailer

  def self.loader
    @@loader ||= register_loader
  end

  def self.reset_loader
    @@loader = nil
  end

  def self.find_emails(priority, quota)
    loader.find_emails(priority, quota)
  end

  def self.delete_email(email)
    loader.delete_email(email)
  end

  private
  def self.register_loader
    @@loader = MonkeyMailer.configuration.loader.new(MonkeyMailer.configuration.loader_options)
  end

  class DeliverError < StandardError; end
end