module StaticPagesHelper
  def to_dollars(cents)
    cents = (cents.to_f)/100
    sprintf('%.2f', cents)
  end
end
