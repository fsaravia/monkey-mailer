require 'spawn'

MailQueue.extend(Spawn).spawner do |mail_queue|
  mail_queue.to_name ||= 'Example User'
  mail_queue.to_email ||= 'user@example.org'
  mail_queue.from_name ||= 'Example Sender'
  mail_queue.from_email ||= 'noreply@example.com'
  mail_queue.subject ||= 'Hey you!'
  mail_queue.body ||= "<html><h1>Title</h1><p>Just some text on the test email</p></html>"
  mail_queue.priority ||= [MailUrgent, MailNormal, MailLow].sample
end