require_relative 'spec_helper'

describe MailQueue do

  before :all do
    @mail_hash = {
      :from_name => 'Test example',
      :from_email => 'test@example.org',
      :to_name => 'Test recipient',
      :to_email => 'test@example.org',
      :subject => "I'm doing some test dude!",
      :body => "<html><h1>Title</h1><p>Just some text on the test email</p></html>"
    }
  end

  it 'should create urgent priority emails' do
    MailQueue.create(@mail_hash.merge(:priority => :urgent)).should be_true
    MailQueue.count(:priority => :urgent).should eq 1
  end

  it 'should create normal priority emails' do
    MailQueue.create(@mail_hash.merge(:priority => :normal)).should be_true
    MailQueue.count(:priority => :normal).should eq 1
  end

  it 'should create low priority emails' do
    MailQueue.create(@mail_hash.merge(:priority => :low)).should be_true
    MailQueue.count(:priority => :low).should eq 1
  end
end