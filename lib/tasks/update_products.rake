namespace :db do
  desc "Fill database with sample data"
  task update: :environment do
    update_api
  end
end

def update_api
  products = Product.all
  puts "============================================="
  puts "#{products.size} products queued up to update"
  puts "============================================="

  errors = []
  bestbuy_counter = 1 # max 6 calls per second
  change_count = 0

  products.each do |p|
    if p.api == "bestbuy"
      if bestbuy_counter % 5 == 0
        sleep(1)
      end
      bestbuy_counter += 1
    end
    if p.api == "amazon"
      sleep(1)
    end

    p.update_details
    if p.changed?
      puts p.inspect
      p.save
      change_count += 1
    end

    if p.errors.any?
      print "F"
      errors << p.url
    else
      print "."
    end
  end
  puts ""

  puts "#{pluralize(change_count, 'product')} updated."

  if errors.any?
    puts "Errors on these following urls:"
    errors.each do |e|
      puts e
    end
  end
end

def pluralize(count, noun)
  count == 1 ? "#{count} #{noun}" : "#{count} #{noun}s"
end