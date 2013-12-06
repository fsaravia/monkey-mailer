require_relative 'spec_helper'

describe Postman do
  describe 'Adapter' do

    before :all do
      Postman.configure do |config|
        config.adapter = 'dummy'
      end
    end

    after :each do
      Postman.reset_adapter
    end

    it 'should register a new adapter when called' do
      Postman.reset_adapter
      Postman.stub(:adapter, {})
      Postman.adapter.should be_nil
      Postman.unstub(:adapter)
      Postman.adapter.respond_to?(:send_mail).should be_true
    end

    it 'should not register the adapter if one has been already registered' do
      Postman.class_variable_set(:@@adapter, Postman::TestAdapter.new)
      Postman.adapter.should be_an_instance_of Postman::TestAdapter
    end

    it 'should register the different avaliable adapters' do
      Postman.reset_adapter
      Postman.configuration.adapter = 'smtp'
      Postman.adapter.should be_an_instance_of Postman::Smtp
      Postman.reset_adapter
      Postman.configuration.adapter = 'mandrilapi'
      Postman.adapter.should be_an_instance_of Postman::MandrilAPI
      Postman.reset_adapter
      Postman.configuration.adapter = 'dummy'
      Postman.adapter.should be_an_instance_of Postman::Dummy
    end
  end
end