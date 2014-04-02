require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  end

  def contact
  end

  def dashboard
    amazon = JSON.parse(open("https://graph.facebook.com/me/friends?access_token=XXX").read)
  end
end
