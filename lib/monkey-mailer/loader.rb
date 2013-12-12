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
    begin
      const = MonkeyMailer::Loaders.const_get(camelize(MonkeyMailer.configuration.loader))
    rescue NameError
      raise LoadError, "Could not find a loader for #{MonkeyMailer.configuration.loader.inspect}. You may need to install additional gems such as mm-#{MonkeyMailer.configuration.loader}"
    end
    @@loader = const.new(MonkeyMailer.configuration.send("#{MonkeyMailer.configuration.loader}_options".to_sym))
  end

  def self.camelize(word)
    word.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end

  class DeliverError < StandardError; end
end