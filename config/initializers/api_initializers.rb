# for amazon gem
Amazon::Ecs.options = {
  :associate_tag => "#{ENV['AMAZON_ASSOCIATE_TAG']}",
  :AWS_access_key_id => "#{ENV['AMAZON_ACCESS_KEY_ID']}",      
  :AWS_secret_key => "#{ENV['AMAZON_SECRET_ACCESS_KEY']}"
}

