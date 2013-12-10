module MonkeyMailer::Loaders
  class FakeLoader

    attr_accessor :queue

    def initialize(opts=nil)
      @queue = {:urgent => [], :normal => [], :low => []}
    end

    def find_emails(priority, quota)
      @queue[priority].sample(quota)
    end

    def delete_email(email)
      @queue[email.priority].delete(email)
    end

    def queue_count
      @queue.values.flatten.size
    end
  end
end