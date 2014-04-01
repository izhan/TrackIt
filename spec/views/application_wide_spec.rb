require 'spec_helper'

describe "All Pages" do
  subject { page }

  describe "For signed in user" do
    describe "Header bar" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
        visit root_path
      end
      it do
        should have_content(@user1.name)
      end
    end
  end
end
