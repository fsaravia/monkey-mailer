module MonkeyMailer::Adapters
  class TestAdapter

    attr_accessor :sent_emails

    def initialize(args=nil)
      @sent_emails = []
    end

    def send_email(email)
      @sent_emails << email
    end
  end
end
