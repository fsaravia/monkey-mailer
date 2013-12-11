module MonkeyMailer

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration

    attr_accessor :adapter, :mandril_api_key, :smtp, :urgent_quota,
    :normal_quota, :low_quota, :normal_sleep, :low_sleep, :sleep, :options,
    :loader

    @@defaults = {
      :adapter => 'mandrilapi',
      :mandril_api_key => 'YOUR_API_KEY',
      :smtp => {
        :address => 'smtp.mandrillapp.com',
        :port => 587,
        :domain => 'example.com',
        :user_name => 'user',
        :password => 'password',
        :authentication => 'plain',
        :enable_starttls_auto => true
      },
      :urgent_quota => 100,
      :normal_quota => 100,
      :low_quota => 100,
      :low_quota => 1,
      :normal_sleep => 12,
      :low_sleep => 54,
      :sleep => 5,
      :loader => 'dummy',
      :options => {:dummy_options => {}}
    }

    def initialize
      @@defaults.each_pair{|key, value| self.send("#{key}=".to_sym,value)}
    end

    def method_missing(*args)
      super unless args[0].to_s.end_with?('_options', 'options=')
      if args[0].to_s.end_with?('=')
        options[args[0].to_s.chop.to_sym] = args[1]
      else
        options[args[0]]
      end
    end
  end
end
