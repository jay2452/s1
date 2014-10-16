require 'rails_helper'

RSpec.describe PagesController, :type => :controller do

  render_views
  before(:each) do
    @base_title = "Ruby on rails Tutorial Sample App"
  end

  describe "Home page" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    it "should have the title 'Home'" do
      visit root_path #'/'
      #get :home
      expect(page).to have_title("#{@base_title} | Home")
    end

    it "should have a non-blank body" do
      get :home
      response.body.should_not =~ /<body>\s*<\/body>/ #regex for blank body
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get :contact
      expect(response).to have_http_status(:success)
    end

    it "should have the title 'Contact'" do
      visit contact_path
      expect(page).to have_title("#{@base_title} | Contact")
    end

  end

    describe "About page" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end

    it "should have the title 'About'" do
      visit about_path #'/about'
      expect(page).to have_title("#{@base_title} | About")
    end

  end

    describe "Help page" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
    end

    it "should have the title 'Help'" do
      visit help_path #'/help'
      expect(page).to have_title("#{@base_title} | Help")
    end

  end

end
