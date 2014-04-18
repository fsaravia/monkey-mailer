module MonkeyMailer
  class Email

    attr_accessor :priority, :to_email, :to_name, :from_email, :from_name, :body, :subject, :attachments

    def initialize(hash=nil)
      self.attachments = []
      unless hash.nil?
        new_attachments = [hash.delete(:attachments)].flatten.compact
        new_attachments.each do |attachment_hash|
          self.attachments << Attachment.new(attachment_hash)
        end

        hash.each_pair{|key, value| self.send("#{key}=", value)}
      end
    end

    class Attachment
      attr_accessor :file_path, :content_type

      def initialize(hash=nil)
        unless hash.nil?
          hash.each_pair{|key, value| self.send("#{key}=", value)}
        end
      end
    end
  end
end