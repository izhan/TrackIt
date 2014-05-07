class AlertMailer < ActionMailer::Base
  helper StaticPagesHelper
  default from: "Thriftster Alerts <alerts@thriftster.com>"

  def alert_email(user, tracker)
    @user = user
    @tracker = tracker
    mail(to: @user.email, subject: "#{@tracker.name} is now on sale!")
  end
end
