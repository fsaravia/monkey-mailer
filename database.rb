require_relative 'models/mail_queue.rb'

module Postman

  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, {
    :adapter  => Postman.config[:database][:adapter],
    :host     => Postman.config[:database][:host],
    :username => Postman.config[:database][:username],
    :password => Postman.config[:database][:password],
    :database => Postman.config[:database][:database]
  })

  DataMapper.finalize
end
