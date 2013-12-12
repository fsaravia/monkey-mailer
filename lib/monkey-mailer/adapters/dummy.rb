module MonkeyMailer
  module Adapters
    class Dummy

      def initialize(options)
      end

      def send_email(email)
        puts email.inspect
      end
    end
  end
end
