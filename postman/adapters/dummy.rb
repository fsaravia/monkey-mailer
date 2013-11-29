module Postman
  class Dummy

    def send_mail(email)
      puts email.as_json
    end
  end
end
