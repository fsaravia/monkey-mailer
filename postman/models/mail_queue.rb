class MailQueue
  include DataMapper::Resource

  property :id, Serial
  property :priority, Discriminator
  property :to, String
  property :from, String
  property :subject, String
  property :body, Text
  
  def initialize(email)
    self.to = email.to
    self.from = email.from
    self.subject = email.subject
    self.body = email.body
  end
end

class MailUrgent < MailQueue
end

class MailNormal < MailQueue
end

class MailLow < MailQueue
end
