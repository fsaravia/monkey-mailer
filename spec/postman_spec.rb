require_relative 'spec_helper'

describe MonkeyMailer do

  before :all do
    MonkeyMailer.configure do |config|
      config.urgent_quota = 10
      config.normal_quota = 1
      config.low_quota = 2
      config.normal_sleep = 1
      config.low_sleep = 2
      config.loader = MonkeyMailer::Loaders::FakeLoader
    end
  end

  after :all do
    MonkeyMailer.class_variable_set(:@@configuration, nil)
  end

  before :each do
    MonkeyMailer.reset_loader
    MonkeyMailer.configuration.loader_options = {:urgent => [], :normal => [], :low => []}
    @adapter = MonkeyMailer::TestAdapter.new
    MonkeyMailer.class_variable_set(:@@adapter, @adapter)
    MonkeyMailer.class_variable_set(:@@normal_sleep, 0)
    MonkeyMailer.class_variable_set(:@@low_sleep, 0)
  end

  it 'should send urgent emails' do
    5.times do
      MonkeyMailer.loader.queue[:urgent] << MonkeyMailer::Email.fake(:urgent)
    end
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 5
    MonkeyMailer.loader.queue[:urgent].size.should eq 0
  end

  it 'should respect the quota for urgent emails' do
    11.times do
      MonkeyMailer.loader.queue[:urgent] << MonkeyMailer::Email.fake(:urgent)
    end
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 10
    MonkeyMailer.loader.queue_count.should eq 1
  end

  it 'should send normal priority emails after sleeping once respecting their quota' do
    4.times do
      MonkeyMailer.loader.queue[:normal] << MonkeyMailer::Email.fake(:normal)
    end
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 0
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 1
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 1
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    MonkeyMailer.loader.queue_count.should eq 2
  end

  it 'should send low priority emails after sleeping twice respecting their quota' do
    5.times do
      MonkeyMailer.loader.queue[:low] << MonkeyMailer::Email.fake(:low)
    end
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 0
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 0
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 2
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 4
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 4
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 4
    MonkeyMailer.find_and_deliver
    @adapter.sent_emails.size.should eq 5
    MonkeyMailer.loader.queue_count.should eq 0
  end

  it 'should send emails respecting sleep times and priorities' do
    50.times do
      MonkeyMailer.loader.queue[:urgent] << MonkeyMailer::Email.fake(:urgent)
    end
    30.times do
      MonkeyMailer.loader.queue[:normal] << MonkeyMailer::Email.fake(:normal)
    end
    15.times do
      MonkeyMailer.loader.queue[:low] << MonkeyMailer::Email.fake(:low)
    end
    MonkeyMailer.loader.queue_count.should eq 95
    MonkeyMailer.find_and_deliver #Should send only 10 urgent emails
    @adapter.sent_emails.size.should eq 10
    MonkeyMailer.loader.queue[:urgent].size.should eq 40
    MonkeyMailer.find_and_deliver #Should send 10 urgent emails and 1 normal email
    @adapter.sent_emails.size.should eq 21
    MonkeyMailer.loader.queue[:urgent].size.should eq 30
    MonkeyMailer.loader.queue[:normal].size.should eq 29
    MonkeyMailer.find_and_deliver #Should send 10 urgent emails and 2 low emails
    @adapter.sent_emails.size.should eq 33
    MonkeyMailer.loader.queue[:urgent].size.should eq 20
    MonkeyMailer.loader.queue[:low].size.should eq 13
    MonkeyMailer.find_and_deliver #Should send 10 urgent emails and 1 normal email
    @adapter.sent_emails.size.should eq 44
    MonkeyMailer.loader.queue[:urgent].size.should eq 10
    MonkeyMailer.loader.queue[:normal].size.should eq 28
    MonkeyMailer.find_and_deliver #Should send only 10 urgent emails
    @adapter.sent_emails.size.should eq 54
    MonkeyMailer.loader.queue[:urgent].size.should eq 0
    MonkeyMailer.find_and_deliver #Should send 1 normal email and 2 low emails
    @adapter.sent_emails.size.should eq 57
    MonkeyMailer.loader.queue[:normal].size.should eq 27
    MonkeyMailer.loader.queue[:low].size.should eq 11
    MonkeyMailer.loader.queue_count.should eq 38
  end

  it 'should not delete the email if delivery failed' do
    MonkeyMailer.reset_adapter
    MonkeyMailer.class_variable_set(:@@adapter, MonkeyMailer::AngryAdapter.new)
    MonkeyMailer.loader.queue[:urgent] << MonkeyMailer::Email.fake(:urgent)
    previous_stdout, $stdout = $stdout, StringIO.new #Redirect stdout to avoid seeing backtrace on console
    MonkeyMailer.find_and_deliver
    $stdout = previous_stdout
    MonkeyMailer.loader.queue_count.should eq 1
  end
end