class AlertMailer < ActionMailer::Base
  helper StaticPagesHelper
  default from: "do_not_reply@thriftster.com"

  def alert_email(user, tracker)
    @user = user
    @tracker = tracker
    mail(to: @user.email, subject: "#{@tracker.name} is now on sale!")
  end
end
