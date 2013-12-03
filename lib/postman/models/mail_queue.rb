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
