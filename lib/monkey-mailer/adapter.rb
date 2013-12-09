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
        delete(email)
      rescue DeliverError => e
        puts e.message
        puts e.backtrace
      end
    end
  end

  private
  def self.register_adapter
    case MonkeyMailer.configuration.adapter
    when 'mandrilapi'
      require_relative 'adapters/mandrilapi'
      @@adapter = MonkeyMailer::MandrilAPI.new(MonkeyMailer.configuration.mandril_api_key)
    when 'smtp'
      require_relative 'adapters/smtp'
      @@adapter = MonkeyMailer::Smtp.new(MonkeyMailer.configuration.smtp)
    when 'dummy'
      require_relative 'adapters/dummy'
      @@adapter = MonkeyMailer::Dummy.new
    else
      raise "Adapter #{MonkeyMailer.configuration.adapter} does not exist"
    end
  end
end