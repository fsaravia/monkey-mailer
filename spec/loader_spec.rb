require_relative 'spec_helper'

describe MonkeyMailer do
  describe 'loader' do

    before :all do
      @current_loader = MonkeyMailer.loader
    end

    after :each do
      MonkeyMailer.reset_loader
    end

    after :all do
      # Other tests may be using the previous set up loader and databasecleaner will drop the db objects
      # If tests get executed with a certain seed
      MonkeyMailer.class_variable_set(:@@loader, @current_loader)
    end

    it 'should register a new loader when called' do
      MonkeyMailer.reset_loader
      MonkeyMailer.stub(:loader, {})
      MonkeyMailer.loader.should be_nil
      MonkeyMailer.unstub(:loader)
      MonkeyMailer.loader.should be_an_instance_of MonkeyMailer::Database
    end

    it 'should not register the loader if one has been already registered' do
      MonkeyMailer.class_variable_set(:@@loader, FakeLoader.new)
      MonkeyMailer.loader.should be_an_instance_of FakeLoader
    end
  end
end