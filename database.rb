require_relative 'models/mail_queue.rb'

module Postman

  DataMapper.setup(:default, Postman.database)
  DataMapper.finalize
end
