module Postman

  def self.loader=(loader)
    @@loader = loader
  end

  def self.loader
    if !@@loader.nil?
      @@loader
    else
      raise 'Loader has not been configured'
    end
  end

  def self.find_mails(priority, quota)
    loader.find_mails(priority, quota)
  end

  def self.delete(mail)
    loader.delete(email)
  end

  case Postman.configuration.loader
  when 'database'
    require_relative 'loaders/database'
    Postman.loader = Postman::Database.new(Postman.configuration.databases)
  else
    raise "Loader #{Postman.configuration.loader} does not exist"
  end
end