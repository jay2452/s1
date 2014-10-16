require 'rails_helper'

RSpec.describe "LayoutLinks", :type => :request do
 # describe "GET /layout_links" do
  #   get layout_links_index_path
   #   expect(response).to have_http_status(200)
    #end
  #end

  before(:each) do
    @base_title = "Ruby on rails Tutorial Sample App"
  end


  it "should have a Home page at '/'" do
  	visit root_path
  	expect(page).to have_title("Home")
  end

 it "should have a Contact page at '/contact'" do
  	visit contact_path
  	expect(page).to have_title("Contact")
  end  

 it "should have a About page at '/about'" do
  	visit about_path
  	expect(page).to have_title("About")
  end  

 it "should have a Help page at '/help'" do
 	visit '/help'
 	expect(page).to have_title("Help")
 end  

 it "should have a signup page at '/signup'" do
   visit '/signup'
   expect(page).to have_title("Sign up")
 end

 it "should have a signin page at '/signin'" do
   visit '/signin'
   expect(page).to have_title("Sign in")
 end

 it "should have the right links on the layout" do
   visit root_path
   expect(page).to have_title("Home")
   click_link "About"
   expect(page).to have_title("About")
   click_link "Contact"
   expect(page).to have_title("Contact")
   click_link "Home"
   expect(page).to have_title("Home")
   click_link "Sign Up now"
   expect(page).to have_title("Sign up")
 end

 describe "when not signed in" do
   it "should have a signin link" do
     visit root_path
     #response.should have_a("Sign in")
   end
 end

 describe "when signed in" do 
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit signin_path
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Sign in'
    end
    #let(:user) { FactoryGirl.create(:user) }
    #before { sign_in user }

   # it "should have a signout link" 
     

    

    #it "should have a profile link" 


   # it "should have a users link" do
    #  visit root_path
     # response.should have_link('Users', href: users_path)
    #end
   # it { should have_link('Users', href: users_path) }
  end

end
