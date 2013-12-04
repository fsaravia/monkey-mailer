class MailQueue
  include DataMapper::Resource

  property :id, Serial
  property :priority, Discriminator
  property :to_email, String, :length => 255, :required => true
  property :to_name, String, :length => 255
  property :from_email, String, :length => 255, :required => true
  property :from_name, String, :length => 255
  property :subject, String, :length => 255
  property :body, Text
end

class MailUrgent < MailQueue
end

class MailNormal < MailQueue
end

class MailLow < MailQueue
end

module Postman
  class Database

    def initialize(sources)
      DataMapper::Logger.new(STDOUT, 'fatal')

      raise ArgumentError, 'One of the database names must be default' unless sources.include?('default')
      sources.each_pair do |name, opts|
        DataMapper.setup(name.to_sym, opts)
      end

      DataMapper.finalize
    end

    def find_mails(priority, quota)
      mails = []
      Postman.database.each_key do |database|
        new_mails = DataMapper.repository(database.to_sym) {priority.all(:limit => quota)}
        quota -= new_mails.size
        mails.concat(new_mails)
      end
      mails
    end

    def delete(email)
      email.destroy
    end
  end
end
