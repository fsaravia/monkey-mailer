require 'mail'

module Postman
  class Smtp
    
    def initialize(options)
      Mail.defaults do
        delivery_method :smtp, options
      end
    end

    def send_mail(email)
      Mail.deliver do
        to email.to
        from email.from
        subject email.subject
        body email.body
      end
    end
  end
end
