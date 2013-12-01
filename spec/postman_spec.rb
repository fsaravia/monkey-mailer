require_relative 'spec_helper'

describe Postman do

  before :all do
    Postman.configure do |config|
      config.urgent_quota = 10
      config.normal_quota = 1
      config.low_quota = 2
      config.normal_sleep = 1
      config.low_sleep = 2
    end
  end

  before :each do
    @adapter = Postman::TestAdapter.new
    Postman.set_adapter(@adapter)
    Postman.class_variable_set(:@@normal_sleep, 0)
    Postman.class_variable_set(:@@low_sleep, 0)
  end

  it 'should send urgent emails' do
    5.times do
      MailQueue.spawn(:priority => MailUrgent)
    end
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 5
    MailQueue.count.should eq 0
  end

  it 'should respect the quota for urgent emails' do
    11.times do
      MailQueue.spawn(:priority => MailUrgent)
    end
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 10
    MailQueue.count.should eq 1
  end

  it 'should send normal priority emails after sleeping once respecting their quota' do
    4.times do
      MailQueue.spawn(:priority => MailNormal)
    end
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 0
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 1
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 1
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    MailQueue.count.should eq 2
  end

  it 'should send low priority emails after sleeping twice respecting their quota' do
    5.times do
      MailQueue.spawn(:priority => MailLow)
    end
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 0
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 0
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 4
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 4
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 4
    Postman.find_and_deliver
    @adapter.sent_emails.size.should eq 5
    MailQueue.count.should eq 0
  end

  it 'should send emails respecting sleep times and priorities' do
    50.times do
      MailQueue.spawn(:priority => MailUrgent)
    end
    30.times do
      MailQueue.spawn(:priority => MailNormal)
    end
    15.times do
      MailQueue.spawn(:priority => MailLow)
    end
    MailQueue.count.should eq 95
    Postman.find_and_deliver #Should send only 10 urgent emails
    @adapter.sent_emails.size.should eq 10
    MailUrgent.count.should eq 40
    Postman.find_and_deliver #Should send 10 urgent emails and 1 normal email
    @adapter.sent_emails.size.should eq 21
    MailUrgent.count.should eq 30
    MailNormal.count.should eq 29
    Postman.find_and_deliver #Should send 10 urgent emails and 2 low emails
    @adapter.sent_emails.size.should eq 33
    MailUrgent.count.should eq 20
    MailLow.count.should eq 13
    Postman.find_and_deliver #Should send 10 urgent emails and 1 normal email
    @adapter.sent_emails.size.should eq 44
    MailUrgent.count.should eq 10
    MailNormal.count.should eq 28
    Postman.find_and_deliver #Should send only 10 urgent emails
    @adapter.sent_emails.size.should eq 54
    MailUrgent.count.should eq 0
    Postman.find_and_deliver #Should send 1 normal email and 2 low emails
    @adapter.sent_emails.size.should eq 57
    MailNormal.count.should eq 27
    MailLow.count.should eq 11
    MailQueue.count.should eq 38
  end
end