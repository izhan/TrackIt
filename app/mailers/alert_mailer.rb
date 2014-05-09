class AlertMailer < ActionMailer::Base
  helper ProductTrackerHelper
  helper StaticPagesHelper
  default from: "Thriftster Alerts <alerts@thriftster.me>"

  def alert_email(user, tracker)
    @user = user
    @tracker = tracker
    mail(to: @user.email, subject: "#{@tracker.name} is now on sale!")
  end
end
