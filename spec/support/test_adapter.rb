module Postman
  class TestAdapter

    attr_accessor :sent_emails

    def initialize
      @sent_emails = []
    end

    def send_mail(email)
      @sent_emails << email
    end
  end
end
