module MonkeyMailer::Loaders
  class Dummy

    def initialize(opts)
    end

    def find_emails(priority, quota)
      emails = []
      quota.times do
        emails << MonkeyMailer::Email.new(:priority => priority, :to_email => 'info@example.com', :to_name => 'Example user',
          :from_email => 'noreply@example.com', :from_name => 'No reply', :subject => 'Lorem ipsum', :body => '')
      end
      emails
    end

    def delete_email(email)
      email = nil
    end
  end
end