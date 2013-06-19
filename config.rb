module Postman

  def self.environment
    @@environment ||= YAML.load_file(File.dirname(__FILE__) + '/config/environment.yaml')
    @@environment['environment']
  end

  def self.database
    @@config ||= YAML.load_file(File.dirname(__FILE__) + '/config/database.yaml')
    @@config[environment]
  end

  class DeliverError < StandardError; end
end
