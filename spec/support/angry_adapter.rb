module MonkeyMailer::Adapters
  class AngryAdapter

    def initialize(args=nil)
    end

    def send_email(email)
      raise MonkeyMailer::DeliverError, "Just testing, don't panic"
    end
  end
end