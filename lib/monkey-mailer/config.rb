module MonkeyMailer

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration

    attr_accessor :adapter, :mandril_api_key, :smtp_address, :smtp_port, :smtp_domain,
    :smtp_user_name, :smtp_password, :smtp_authentication, :smtp_enable_starttls_auto,
    :urgent_quota, :normal_quota, :low_quota, :normal_sleep, :low_sleep, :sleep, :options,
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

    @@config_file = "#{File.dirname(__FILE__)}/../../config/settings.yaml"

    def initialize
      user_settings = File.exists?(@@config_file) ? YAML.load_file(@@config_file) : {}
      @@defaults.each_pair do |key, value|
        if key === :options
          @options = user_settings['options'] || value
        else
          value = user_settings[key.to_s] if user_settings.include?(key.to_s)
          if value.is_a?(Hash)
            value.each_pair {|sub_key, sub_value| self.send("#{key}_#{sub_key}=".to_sym, sub_value)}
          else
            self.send("#{key}=".to_sym,value)
          end
        end
      end
    end

    def method_missing(*args)
      super unless options.include?(args[0])
      options[args[0]]
    end

    def smtp
      options = {}
      @@defaults[:smtp].each_key do |property|
        options["smtp_#{property}".to_sym] = self.send("smtp_#{property}".to_sym)
      end
    end
  end
end
