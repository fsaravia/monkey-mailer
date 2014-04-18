require 'mail'

module MonkeyMailer
  module Adapters
    class Smtp

      # Options
      # :address => 'smtp.mandrillapp.com',
      # :port => 587,
      # :domain => 'example.com',
      # :user_name => 'user',
      # :password => 'password',
      # :authentication => 'plain',
      # :enable_starttls_auto => true
      def initialize(options)
        Mail.defaults do
          delivery_method :smtp, options.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        end
      end

      def send_email(email)
        Mail.deliver do
          to "#{email.to_name} <#{email.to_email}>"
          from "#{email.from_name} <#{email.from_email}>"
          subject email.subject

          email.attachments.each do |attachment|
            add_file :filename => File.basename(attachment.file_path), :content => File.read(attachment.file_path)
          end

          html_part do
            content_type 'text/html; charset=UTF-8'
            body email.body
          end

          text_part do
            body email.body.nil? ? '' : email.body.gsub(/<\/?[^>]*>/, "")
          end
        end
      end
    end
  end
end