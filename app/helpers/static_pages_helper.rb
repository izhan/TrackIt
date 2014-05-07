module StaticPagesHelper
  def to_dollars(cents)
    cents = (cents.to_f)/100
    sprintf('%.2f', cents)
  end

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end
end
