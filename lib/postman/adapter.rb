module Postman

  def self.adapter
    @@adapter ||= register_adapter
  end

  def self.deliver(email)
    if !@@adapter.nil?
      @@adapter.send_mail(email)
    else
      raise 'Adapter has not been configured'
    end
  end

  def self.send_mails(mails)
    mails.each do |mail|
      begin
        deliver(mail)
        mail.destroy
      rescue DeliverError => e
        puts e.message
        puts e.backtrace
      end
    end
  end

  def self.register_adapter
    case Postman.configuration.adapter
    when 'mandrilapi'
      require_relative 'adapters/mandrilapi'
      @@adapter = Postman::MandrilAPI.new(Postman.configuration.mandril_api_key)
    when 'smtp'
      require_relative 'adapters/smtp'
      @@adapter = Postman::Smtp.new(Postman.configuration.smtr)
    when 'dummy'
      require_relative 'adapters/dummy'
      @@adapter = Postman::Dummy.new
    else
      raise "Adapter #{Postman.configuration.adapter} does not exist"
    end
  end
end