# coding: utf-8

require 'spec_helper'

describe "LayoutLinks" do

	it "should have a Home page at '/'" do
    	get '/'
    	response.should have_selector('title', :content => "Главная")
  	end

  	it "should have a Contact page at '/contact'" do
    	get '/contact'
    	response.should have_selector('title', :content => "Наши контакты")
 	end

  	it "should have an About page at '/about'" do
    	get '/about'
    	response.should have_selector('title', :content => "О проекте")
  	end

  	it "should have a Help page at '/help'" do
    	get '/help'
    	response.should have_selector('title', :content => "Помощь")
  	end

  	it "should have a signup page at '/signup'" do
    	get '/signup'
    	response.should have_selector('title', :content => "Регистрация")
  	end



	it "should have the right links on the layout" do
    	visit root_path
    	click_link "О проекте"
    	response.should have_selector('title', :content => "О проекте")
    	click_link "Помощь"
    	response.should have_selector('title', :content => "Помощь")
    	click_link "Наши контакты"
    	response.should have_selector('title', :content => "Наши контакты")
    	click_link "Главная"
    	response.should have_selector('title', :content => "Главная")
    	click_link "Регистрация!"
    	response.should have_selector('title', :content => "Регистрация")
  	end


	describe "when not signed in" do
		
		it "should have a signed in link" do
			visit signin_path
			response.should have_selector( "a", :href => signin_path,
											:content => "Вход" )
		end

	end

	describe "when signed in" do

		before(:each) do
			@user = Factory(:user)
			integrations_sign_in(@user)
		end


		it "should have a signed out link" do
			visit root_path
			response.should have_selector( "a", :href => signout_path,
												:content => "Выход")
		end
	end



end
