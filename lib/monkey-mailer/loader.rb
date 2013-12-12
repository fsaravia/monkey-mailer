require 'monkey-mailer/loaders/dummy'

module MonkeyMailer

  def self.loader
    @@loader ||= register_loader
  end

  def self.reset_loader
    @@loader = nil
  end

  private
  def self.register_loader
    @@loader = MonkeyMailer.configuration.loader.new(MonkeyMailer.configuration.loader_options)
  end
end
