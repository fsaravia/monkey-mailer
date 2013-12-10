module MonkeyMailer
  class Email

    attr_accessor :priority, :to_email, :to_name, :from_email, :from_name, :body, :subject

    def initialize(hash=nil)
      unless hash.nil?
        hash.each_pair{|key, value| self.send("#{key}=", value)}
      end
    end
  end
end