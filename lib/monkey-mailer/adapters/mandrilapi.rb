require "net/http"
require "uri"
require "json"
require 'base64'

module MonkeyMailer
  module Adapters
    class MandrilAPI

      @key = ''

      def initialize(options)
        @key = options[:mandril_api_key]
      end

      def send_email(email)

        request_body = {
          :key => @key,
          :message => {
            :to => parse_recipients(email.to_email, email.to_name),
            :from_name => email.from_name,
            :from_email => email.from_email,
            :subject => email.subject,
            :html => email.body,
            :text => email.body.to_s.gsub(/<\/?[^>]*>/, ""),
            :headers => {},
            :track_opens => true,
            :track_clicks => true,
            :auto_text => true,
            :url_strip_qs => true,
            :preserve_recipients => false,
            :bcc_address => '',
            :attachments => []
          },
          :async => false
        }

        email.attachments.each do |attachment|
          request_body[:message][:attachments] << {
            :type => attachment.content_type,
            :name => File.basename(attachment.file_path),
            :content => Base64.encode64(File.read(attachment.file_path))
          }
        end

        uri = URI('https://mandrillapp.com')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new('/api/1.0/messages/send.json', initheader = {'Content-Type' =>'application/json'})
        request.body = request_body.to_json

        response = http.start {|http| http.request(request)}

        raise MonkeyMailer::DeliverError.new("Mandril response.code not equal to 200") unless response.code.to_i == 200
        puts "Response #{response.code} #{response.message}: #{response.body}"
      end

      def parse_recipients(recipients_list, names_list = "")
        recipients = recipients_list.split(",")
        names      = names_list.to_s.split(",")
        to_list    = []

        raise RuntimeError.new("No recipients specified") if recipients.empty?

        if names.any? && (names.count != recipients.count)
          raise RuntimeError.new("Recipients and Names lists don't match")
        end

        recipients.each_with_index do |recipient, idx|
          to_list << { "email" => recipient.strip,
                       "name" => names[idx] ? names[idx].strip : "",
                       "type" => "to" }
        end

        to_list
      end

    end
  end
end
