require 'mail'

module MonkeyMailer
  class Smtp

    def initialize(options)
      Mail.defaults do
        delivery_method :smtp, options
      end
    end

    def send_email(email)
      Mail.deliver do
        to "#{email.to_name} <#{email.to_email}>"
        from "#{email.from_name} <#{email.from_email}>"
        subject email.subject

        html_part do
          content_type 'text/html; charset=UTF-8'
          body email.body
        end

        text_part do
          body email.body.gsub(/<\/?[^>]*>/, "")
        end
      end
    end
  end
end
