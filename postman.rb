require 'fallen'
require 'fallen/cli'
require 'data_mapper'
require_relative 'config'

Postman.set_env(:test)

require_relative 'database'

module Postman
  extend Fallen
  extend Fallen::CLI

  def self.run
    while running?
      mails = MailQueue.all
      puts mails.inspect
      sleep 5
    end
  end

  def self.usage
    puts fallen_usage
  end
end

case Clap.run(ARGV, Postman.cli).first

when "start"
  Postman.start!
when "stop"
  Postman.stop!
else
  Postman.usage
end

