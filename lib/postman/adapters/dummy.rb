module Postman
  class Dummy

    def send_email(email)
      puts email.as_json
    end
  end
end
