namespace :db do
  desc "Get information about Usage"
  task stats: :environment do
    puts "========================================================================="
    puts "Statistics for #{Time.current}"
    puts "========================================================================="
    print_stats
  end
end

def print_stats
  total_users = User.all.size
  total_trackers = Tracker.all.size
  total_products = Product.all.size
  puts "Total Users: #{total_users}"
  puts "Total Trackers: #{total_trackers}"
  puts "Total Products: #{total_products}"
  puts "========================================================================="
  puts "Average Number of Trackers per User: #{sprintf('%.2f', 1.0 * total_trackers/total_users)}"

  number_of_savings = 0
  amount_in_savings = 0
  Tracker.all.each do |t|
    a_price = t.alert_price
    c_price = t.product.current_price
    if a_price > c_price
      number_of_savings = number_of_savings + 1
      amount_in_savings = amount_in_savings + a_price - c_price
    end
  end

  puts "Total Number of Price Drops: #{number_of_savings}"
  puts "Total Amount in Savings: $#{to_dollars(amount_in_savings)}"
end

def to_dollars(cents)
  cents = (cents.to_f)/100
  sprintf('%.2f', cents)
end