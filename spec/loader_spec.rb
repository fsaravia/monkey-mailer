require_relative 'spec_helper'

describe Postman do
  describe 'loader' do

    before :all do
      @current_loader = Postman.loader
    end

    after :each do
      Postman.reset_loader
    end

    after :all do
      # Other tests may be using the previous set up loader and databasecleaner will drop the db objects
      # If tests get executed with a certain seed
      Postman.class_variable_set(:@@loader, @current_loader)
    end

    it 'should register a new loader when called' do
      Postman.reset_loader
      Postman.stub(:loader, {})
      Postman.loader.should be_nil
      Postman.unstub(:loader)
      Postman.loader.should be_an_instance_of Postman::Database
    end

    it 'should not register the loader if one has been already registered' do
      Postman.class_variable_set(:@@loader, FakeLoader.new)
      Postman.loader.should be_an_instance_of FakeLoader
    end
  end
end