namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_trackers
  end
  task users: :environment do
    make_users
  end
  task trackers: :environment do
    make_trackers
  end
end

def make_users
  easyloginuser = User.create!(first_name: "ASDF",
    last_name: "User",
    email:    "asdf@asdf.com",
    password: "asdfasdf",
    password_confirmation: "asdfasdf",
    confirmed_at: Time.now.yesterday
    )
  irvin = User.create!(first_name: "Irvin",
    last_name: "Zhan",
    email:    "izhan@princeton.edu",
    password: "asdfasdf",
    password_confirmation: "asdfasdf",
    confirmed_at: Time.now.yesterday
    )
  haley = User.create!(first_name: "Haley",
    last_name: "Beck",
    email:    "hebeck@princeton.edu",
    password: "asdfasdf",
    password_confirmation: "asdfasdf",
    confirmed_at: Time.now.yesterday
    )
end

def make_trackers
  testinguser = User.create!(first_name: "Test",
    last_name: "User",
    email:    "test@test.com",
    password: "asdfasdf",
    password_confirmation: "asdfasdf",
    confirmed_at: Time.now.yesterday
  )
  amazon_urls = [
    "http://www.amazon.com/gp/product/B009FNCF6K",
    "http://www.amazon.com/gp/product/1594633177/ref=s9_al_bw_g14_i1?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-3&pf_rd_r=1TB1E1DSB0R439EPS0QH&pf_rd_t=101&pf_rd_p=1769916722&pf_rd_i=390919011",
    "http://www.amazon.com/gp/product/0307962903/ref=s9_al_bw_g14_i2?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-3&pf_rd_r=1TB1E1DSB0R439EPS0QH&pf_rd_t=101&pf_rd_p=1769916722&pf_rd_i=390919011",
    "http://www.amazon.com/gp/product/0385351410/ref=s9_al_bw_g14_i3?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-3&pf_rd_r=1TB1E1DSB0R439EPS0QH&pf_rd_t=101&pf_rd_p=1769916722&pf_rd_i=390919011",
    "http://www.amazon.com/gp/product/0061896454/ref=s9_al_bw_g14_i4?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-3&pf_rd_r=1TB1E1DSB0R439EPS0QH&pf_rd_t=101&pf_rd_p=1769916722&pf_rd_i=390919011",
    "http://www.amazon.com/gp/product/0804177872/ref=s9_al_bw_g14_i5?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-3&pf_rd_r=1TB1E1DSB0R439EPS0QH&pf_rd_t=101&pf_rd_p=1769916722&pf_rd_i=390919011",
    "http://www.amazon.com/Xbox-360-4GB/dp/B00D9EPI38/ref=sr_1_1_title_0?s=videogames&ie=UTF8&qid=1397685174&sr=1-1&keywords=xbox+360",
    "http://www.amazon.com/Xbox-360-250GB-Holiday-Value-Bundle/dp/B00FATRKOK/ref=sr_1_1_title_1?s=videogames&ie=UTF8&qid=1397685174&sr=1-1&keywords=xbox+360",
    "http://www.amazon.com/Xbox-360-Pro-20-GB/dp/B00309S9YW/ref=sr_1_4?s=videogames&ie=UTF8&qid=1397685174&sr=1-4&keywords=xbox+360"
  ]
  bestbuy_urls = [
    "http://www.bestbuy.com/site/zagg-invisibleshield-hd-for-apple-iphone-5-5s-and-5c/6559029.p?id=1218754594168&skuId=6559029",
    "http://www.bestbuy.com/site/zagg-invisibleshield-for-apple-iphone-5-5s-and-5c/6559047.p?id=1218754594435&skuId=6559047",
  ]

  bestbuy_counter = 1 # limit to 6 a second
  puts "Creating #{amazon_urls.size + bestbuy_urls.size} Trackers"
  amazon_urls.each do |url|
    testinguser.trackers.create(url: url)
    sleep(1)
    print "."
  end

  bestbuy_urls.each do |url|
    if bestbuy_counter % 5 == 0
      sleep(1)
    end
    testinguser.trackers.create(url: url)
    bestbuy_counter += 1
    print "."
  end
  puts ""
  puts "#{testinguser.trackers.size} total trackers created"
end