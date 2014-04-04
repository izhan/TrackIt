require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      # describe "in the Microposts controller" do

      #   describe "submitting to the create action" do
      #     before { post microposts_path }
      #     specify { expect(response).to redirect_to(signin_path) }
      #   end

      #   describe "submitting to the destroy action" do
      #     before { delete micropost_path(FactoryGirl.create(:micropost)) }
      #     specify { expect(response).to redirect_to(signin_path) }
      #   end
      # end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before do
            visit edit_user_registration_path
          end
          it "redirects to sign in" do
            current_path.should == new_user_session_path
          end
        end
      end
    end
  end
end