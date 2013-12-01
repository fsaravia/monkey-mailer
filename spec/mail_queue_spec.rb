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

  it 'should create some urgent priority emails' do
    MailQueue.create(@mail_hash.merge(:priority => MailUrgent)).should be_true
    MailUrgent.create(@mail_hash).should be_true
    MailUrgent.count.should eq 2
  end

  it 'should create some normal priority emails' do
    MailQueue.create(@mail_hash.merge(:priority => MailNormal)).should be_true
    MailNormal.create(@mail_hash).should be_true
    MailNormal.count.should eq 2
  end

  it 'should create some low priority emails' do
    MailQueue.create(@mail_hash.merge(:priority => MailLow)).should be_true
    MailLow.create(@mail_hash).should be_true
    MailLow.count.should eq 2
  end
end