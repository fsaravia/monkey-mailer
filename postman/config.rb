module Postman

  def self.database
    @@database ||= YAML.load_file(File.dirname(__FILE__) + '/../config/database.yaml')
  end

  def self.settings
    @@settings ||= YAML.load_file(File.dirname(__FILE__) + '/../config/settings.yaml')
  end

  class DeliverError < StandardError; end
end
