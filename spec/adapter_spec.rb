require_relative 'spec_helper'

describe MonkeyMailer do
  describe 'Adapter' do

    before :all do
      MonkeyMailer.configure do |config|
        config.adapter = MonkeyMailer::Adapters::Dummy
      end
    end

    after :each do
      MonkeyMailer.reset_adapter
    end

    it 'should register a new adapter when called' do
      MonkeyMailer.reset_adapter
      MonkeyMailer.stub(:adapter, {})
      MonkeyMailer.adapter.should be_nil
      MonkeyMailer.unstub(:adapter)
      MonkeyMailer.adapter.respond_to?(:send_email).should be_true
    end

    it 'should not register the adapter if one has been already registered' do
      MonkeyMailer.class_variable_set(:@@adapter, MonkeyMailer::Adapters::TestAdapter.new)
      MonkeyMailer.adapter.should be_an_instance_of MonkeyMailer::Adapters::TestAdapter
    end
  end
end