module Postman
  @@environment = :development

  @@config = {
    :development => {
      :database => {
        :adapter => 'mysql',
        :host => 'localhost',
        :username => 'root',
        :password => 'password',
        :database => 'test_dev'
      }
    },
    :test => {
      :database => {
        :adapter => 'mysql',
        :host => 'localhost',
        :username => 'root',
        :password => 'password',
        :database => 'test_test'
      }
    },
    :production => {
      :database => {
        :adapter => 'mysql',
        :host => 'localhost',
        :username => 'root',
        :password => 'password',
        :database => 'test_production'
      }
    }
  }

  def self.config
    @@config[@@environment]
  end

  def self.set_env(env)
    @@environment = env if [:development, :test, :production].include? env
  end

end

Postman.set_env(:test)
