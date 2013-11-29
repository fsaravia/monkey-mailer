require_relative 'models/mail_queue.rb'

module Postman

  raise ArgumentError, 'One of the database names must be default' unless Postman.database.include?('default')
  Postman.database.each do |name, values|
    DataMapper.setup(name.to_sym, values)
  end
  DataMapper.finalize
end
