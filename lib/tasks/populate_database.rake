namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end

def make_users
  easyloginuser = User.create!(first_name: "Testing",
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
