module MonkeyMailer
  class Dummy

    def send_email(email)
      puts email.inspect
    end
  end
end
