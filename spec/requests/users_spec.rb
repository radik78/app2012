# coding: utf-8

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
													:content => "Добро")				
					response.should render_template('users/show')
				end.should change(User, :count).by(1)
			end

		end

		
	end


	describe "sign in/out" do
		
		describe "failure" do
			it "should not sign user in" do
				user = User.new(:email =>"", :password =>"")
				integrations_sign_in(user)
				response.should have_selector("div.flash.error", :content => "Некорректная комбинация")
			end
		end

		describe "success" do
			it "should sign a user in and out" do
				user = Factory(:user)
				integrations_sign_in(user)
				controller.should be_signed_in
				click_link "Выход"
				controller.should_not be_signed_in
			end

		end
		
	end
 
 
end




