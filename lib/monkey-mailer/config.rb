module MonkeyMailer

  def self.configuration
    @@configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration

    attr_accessor :urgent_quota, :normal_quota, :low_quota, :normal_sleep,
    :low_sleep, :sleep, :loader, :loader_options, :adapter, :adapter_options

    @@defaults = {
      :urgent_quota => 100,
      :normal_quota => 100,
      :low_quota => 100,
      :low_quota => 1,
      :normal_sleep => 12,
      :low_sleep => 54,
      :sleep => 5,
      :loader => MonkeyMailer::Loaders::Dummy,
      :loader_options => {},
      :adapter => MonkeyMailer::Adapters::Dummy,
      :adapter_options => {}
    }

    def initialize
      @@defaults.each_pair{|key, value| self.send("#{key}=".to_sym,value)}
    end
  end
end
