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

  def self.delete(email)
    loader.delete(email)
  end

  private
  def self.register_loader
    case MonkeyMailer.configuration.loader
    when 'database'
      require_relative 'loaders/database'
      @@loader = MonkeyMailer::Database.new(MonkeyMailer.configuration.databases)
    else
      raise "Loader #{MonkeyMailer.configuration.loader} does not exist"
    end
  end

  class DeliverError < StandardError; end
end