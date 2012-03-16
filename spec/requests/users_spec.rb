require 'spec_helper'

describe "Users" do


	describe "signup" do

		#----Тестирование сбоя регистрации------
		describe "failure" do

		  it "should not make a new user" do
			lambda do
		    	visit signup_path
		    	fill_in "Name",         :with => ""
		    	fill_in "Email",        :with => ""
		    	fill_in "Password",     :with => ""
		    	fill_in "Confirmation", :with => ""
		    	click_button
		    	response.should render_template('users/new')
		    	response.should have_selector("div#error_explanation")
			end.should_not change(User, :count)
		  end

		end

		#---- Успешная регистрация пользователя должна создавать нового пользователя ---------

		describe "success" do

			it "should make a new user" do
				lambda do
					visit signup_path
					fill_in "Name",			:with => "Batman"
					fill_in "Email",		:with => "bat@mail.com"
					fill_in "Password",		:with => "123456"
					fill_in "Confirmation", :with => "123456"
					click_button
					response.should have_selector("div.flash.success",
													:content => "Welcome")				
					response.should render_template('users/show')
				end.should change(User, :count).by(1)
			end

		end

		
	end
 
 
end
