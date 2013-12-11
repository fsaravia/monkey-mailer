module MonkeyMailer
  class Email

    def self.fake(priority = nil)
      priority ||= [:urgent, :normal, :low].sample
      Email.new({:priority => priority})
    end
  end
end