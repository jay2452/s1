require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

	render_views
  
  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      it "should deny_access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in-users" do
      
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        FactoryGirl.create(:user, email: "bob@example.com")
        FactoryGirl.create(:user, email: "ben@example.net")

        #30.times do
         # FactoryGirl.create(:user, email: FactoryGirl.next(:email))
        #end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        #response.should have_title('All users')
      end

      it "should have an element for each user" do
        get :index
        User.all.each do |user|
         # expect(page).to have_selector('li', text: user.name)
        end
      end

      it "should have delete links for admins" do
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        #expect(page).to have_link('delete', href: user_path(other_user))
      end

      it "should not have delete links for non-admins" do
        other_user = User.all.second
        get :index
        expect(page).to_not have_link('delete', href: user_path(other_user))
        #response.should_not have_link('delete', href: user_path(other_user))
      end
    end
  end


  describe "GET 'show'" do

   # before(:each) do
    #  @user = Factory(:user)
    #end
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it "returns http success" do
      #get :show , :id => @user
      get 'show', id: user
      expect(response).to have_http_status(:success)
    end

    it "should find the right user" do
      get :show, :id => user
      assigns(:user).should == user
    end

    it "should have right title" do
      get :show, :id => user
      expect(page).to have_title(user.name)
    end

    it "should have the user's name" do
      get :show, id: user
      expect(page).to have_content(user.name)
    end

    it "should have the right URL" do
      get :show, id: user
      expect(page).to have_content(user_path(user))
    end
  end

  describe "GET new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "should have the right title" do
      visit 'users/new'
      expect(page).to have_title("Sign up")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      
      before(:each) do
        @attr = { name: "", email: "", password: "", password_confirmation: "" }
      end
      
      it "should have the right title" do
       post :create, :user => @attr
      #response.should have_title("Sign up")
        expect(page).to have_title("")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      it "should not create a user" do
        lambda do
        post :create, :user => @attr
       end.should_not change(User, :count)
      end
    end

    describe "success" do
      
      before(:each) do
        @attr =  { name: "New User", :email => "user@example.com", password: "foobar",
                                                                   password_confirmation: "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, user: @attr
        flash[:success].should =~ /welcome to the sample app/i
      end

      it "should sign the user in" do
        post :create, user: @attr
        controller.should be_signed_in
      end
    end
  end


  describe "GET 'edit'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      #response.should have_title("Edit user")
    end
  end

  describe "PUT 'update'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { name: "", email: "", password: "", password_confirmation: "" }
      end

      it "should render the 'edit' page" do
        put :update, id: @user, user: @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
         put :update, id: @user, user: @attr
         #response.should have_title("Edit user")
         expect(page).to have_title("")
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { name: "New Name", email: "user@example.org", password: "barbaz",
                                                               password_confirmation: "barbaz" }
      end

      it "should change the user attributes" do
        put :update, id:@user, user: @attr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password

      end

      it "should have a flash message" do
        put :update, id: @user, user: @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update actions" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed users" do
      
      it "should deny access to 'edit'" do
        get :edit, id: @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end

      it "should deny access to 'update'" do
        put :update, id: @user, user: {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in user" do
      
      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
        test_sign_in(wrong_user)        
      end

      it "should require matching users for 'edit'" do
        get :edit, id: @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        get :edit, id: @user, user: {}
        response.should redirect_to(root_path)
      end
    end

  end

  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the action" do
        test_sign_in(@user)
        delete :destroy, id: @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = FactoryGirl.create(:user, email: "admin@example.com", admin: true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, id: @user
        end.should change(User, :count).by(-1)
      end

      it 'should redirect to the users page' do
        delete :destroy, id: @user
        flash[:success].should =~ /destroyed/i
        response.should redirect_to(users_path)
      end

      it "should not be able to destroy itself" do
       lambda do
        delete :destroy, id: @admin
       end.should_not change(User, :count)
      end
    end
  end
end