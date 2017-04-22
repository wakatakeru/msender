require 'test_helper'

class MailerMailerTest < ActionMailer::TestCase
  test "send_minutes" do
    mail = MailerMailer.send_minutes
    assert_equal "Send minutes", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
