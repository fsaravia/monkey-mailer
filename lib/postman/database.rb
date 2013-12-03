require_relative 'models/mail_queue.rb'

module Postman

  DataMapper::Logger.new(STDOUT, 'fatal')

  raise ArgumentError, 'One of the database names must be default' unless Postman.database.include?('default')
  Postman.database.each do |name, values|
    DataMapper.setup(name.to_sym, values)
  end

  DataMapper.finalize

  def self.find_mails(priority, quota)
    mails = []
    Postman.database.each_key do |database|
      new_mails = DataMapper.repository(database.to_sym) {priority.all(:limit => quota)}
      quota -= new_mails.size
      mails.concat(new_mails)
    end
    mails
  end
end
