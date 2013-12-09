module MonkeyMailer
  class AngryAdapter
    def send_email(email)
      raise DeliverError, "Just testing, don't panic"
    end
  end
end