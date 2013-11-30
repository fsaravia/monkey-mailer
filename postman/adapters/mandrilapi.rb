require "net/http"
require "uri"
require "json"

module Postman
  class MandrilAPI
    @key = ''
    @request = {}
    @uri = ''

    ENDPOINT = 'https://mandrillapp.com/api/1.0'

    def initialize(key)
      @key = key
      @request = Hash.new
      @uri = URI.parse(URI.encode(ENDPOINT))
    end

    def send_mail(email)

      @request = {
        :key => '',
        :message => {
          :html => '',
          :text => '',
          :subject => '',
          :from_email => '',
          :from_name => '',
          :to => [],
          :headers => {},
          :track_opens => true,
          :track_clicks => true,
          :auto_text => true,
          :url_strip_qs => true,
          :preserve_recipients => false,
          :bcc_address => '',
        },
        :async => true
      }

      @request[:key] = @key
      @request[:message][:to] << { :email => email.to_email, :name => email.to_name}
      @request[:message][:from_name] = email.from_name
      @request[:message][:from_email] = email.from_email
      @request[:message][:html] = email.body
      @request[:message][:text] = email.body.gsub(/<\/?[^>]*>/, "")
      @request[:message][:subject] = email.subject

      req = Net::HTTP::Post.new('/api/1.0/messages/send.json', initheader = {'Content-Type' =>'application/json'})
      req.body = @request.to_json

      http = Net::HTTP.new(@uri.host, @uri.port)
      http.use_ssl = true
      response = http.start {|http| http.request(req)}
      raise DeliverError.new("Mandrill response.code not equal to 200") unless response.code.to_i == 200
      puts "Response #{response.code} #{response.message}: #{response.body}"
    end
  end
end
