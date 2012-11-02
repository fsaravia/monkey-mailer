require "net/http"
require "uri"
require "json"

class MandrilAPI 
  @key = ''
  @request = ''
  @uri = ''

  ENDPOINT = 'https://mandrillapp.com/api/1.0'
  REQUEST_TEMPLATE = {
    :key => '',
    :message => {
      :html => '',
      :text => '',
      :subject => '',
      :from_mail => '',
      :from_name => '',
      :to => [],
      :headers => {},
      :track_opens => true,
      :track_clicks => true,
      :auto_text => true,
      :url_strip_qs => true,
      :preserve_recipients => true,
      :bcc_address => '',
    },
    :async => true
  }.to_hash

  def initialize(key)
    @key = key
    @request = Hash.new.merge!(REQUEST_TEMPLATE)
    @request[:key] = @key
    @uri = URI.parse(URI.encode(ENDPOINT))
  end

  def send_mail(email)
    @request[:message][:to] << { :email => email.to, :name => ''}
    @request[:message][:from_name] = 'Plupin.com'
    @request[:message][:from_mail] = email.from
    @request[:message][:html] = email.body
    @request[:message][:text] = email.body.gsub(/<\/?[^>]*>/, "")
    @request[:message][:subject] = email.subject
    @request[:async] = false

    req = Net::HTTP::Post.new('/api/1.0/messages/send.json', initheader = {'Content-Type' =>'application/json'})
    req.body = @request.to_json

    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    response = http.start {|http| http.request(req) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
  end
end
