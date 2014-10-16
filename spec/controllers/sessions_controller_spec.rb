require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

	render_views

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "should have the right title" do
      visit 'sessions/new'
      expect(page).to have_title("Sign in")
    end
  end

  describe "POST 'create'" do
  	describe "failure" do
  		before(:each) do
  			@attr = { email: "", :password => "" }
  		end

  		it "should re-render the new page" do
  			post :create, :session => @attr
  			response.should render_template('new')
  		end

  		it "should have the right title" do
  			post :create, session: @attr
  			expect(page).to have_title("")
  		end

  		it "should have an error message" do
  			post :create, session: @attr
  			flash.now[:error].should =~ /invalid/i
  		end
  	end

  	describe "success" do
  		
    	#before { visit user_path(user) }

  		before(:each) do
  			#let(:user) { FactoryGirl.create(:user) }
  			@user = FactoryGirl.create(:user)
  			@attr = { email: @user.email, password: @user.password }
  		end

 		it "should sign the user in" do
 			post :create, session: @attr
  			controller.current_user.should == @user
  			controller.should be_signed_in
  		end

  		it "should redirect to user show page" do
  			post :create, session: @attr
  			response.should redirect_to(user_path(@user))
  		end
  	end
  end

  describe "DELETE 'destroy'" do
  	it "should sign a user out" do
  		test_sign_in(FactoryGirl.create(:user))
  		delete :destroy
  		controller.should_not be_signed_in
  		response.should redirect_to(root_path)
  	end
  end

end
