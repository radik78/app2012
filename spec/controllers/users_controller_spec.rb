# coding: utf-8

require 'spec_helper'
require 'will_paginate'

describe UsersController do
    render_views

	#====================================================================
	describe "GET 'new'" do

		it "should be successful" do
			get :new
			response.should be_success
		end

    	it "should have the right title" do
      		get :new
      		response.should have_selector("title", :content => "Регистрация")
    	end

	end

	#====================================================================
	describe "GET 'show'" do

		before(:each) do
			@user = Factory(:user)
		end

		it "should be successful" do
			get :show, :id=>@user
			response.should be_success
		end

		it "should be right user" do
			get :show, :id=>@user.id
			assigns(:user)==@user
		end


		it "should have the right title" do
			get :show, :id => @user
			response.should have_selector("title", :content => @user.name)
		end

		it "should include the user's name" do
			get :show, :id => @user
			response.should have_selector("h1", :content => @user.name)
		end

		it "should have a profile image" do
			get :show, :id => @user
			response.should have_selector("h1>img", :class => "gravatar")
		end


	end



	#====================================================================
	describe "failure create new user" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Регистрация")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

  	end



	#====================================================================
	describe "success create new user" do

		before(:each) do
			@attr = { 	:name 					=> "New User",
						:email 					=> "super@mail.ru",
						:password 				=> "aaaaaa",
						:password_confirmations => "aaaaaa"
					}
		end

		#--- проверим что стало на одного пользователя больше при правильных параметрах ---
		it "should create a user" do
		    lambda do
		      post :create, :user => @attr
		    end.should change(User, :count).by(1)
		end

		#--- проверим, что после правильной регистрации нового пользователя переходим на страницу пользователя ----
		it "should redirect to the user show page" do
		    post :create, :user => @attr
		    response.should redirect_to(user_path(assigns(:user)))
		end

		#--- проверим, что после правильной регистрации нового пользователя появляется FLASH сообщение ----
		it "should have a welcome message" do
			post :create, :user => @attr
		    flash[:success].should =~ /Добро пожаловать/i
		end

 		#--- проверим, что после правильной регистрации нового пользователя он будет в сессии
		it "should sign the user in" do
			post :create, :user=>@attr
			controller.should be_signed_in
		end


	end

	#====================================================================
	describe "GET 'edit'" do

		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
			get :edit, :id => @user
		end


		it "should be successful" do
			response.should be_success
		end

		it "should have a rigth title" do
			response.should have_selector("title", :content=>'Редактирование')
		end

		it "should have a link to change the Gravatar" do
			response.should have_selector("a", :content=>'change')
		end

	end


	#===================================================================
	describe "PUT 'update' user" do

		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end

		describe "failure" do

			before(:each) do
				@attr = {:name=>"", :email=>"", :password=>"", :confirm_password=>""}
				put :update, :id=>@user, :user=>@attr
			end

			it "should render the 'edit' page" do
				response.should render_template 'edit'
			end

			it "should have right title" do
				response.should have_selector 'title', :content=>'Редактирование'
			end

		end

		describe "success" do
			before(:each) do
				@attr = { :name=>"New name", :email=>"new_email@mail.com", :password=>"qwertyu", :confirm_password=>"qwertyu"}
				put :update, :id=>@user, :user=>@attr
			end

			it "should redirect the 'user' page" do
				response.should redirect_to (user_path(@user))
			end

			it "should change the user's attributes" do
				@user.reload
				@user.name.should == @attr[:name]
				@user.email.should == @attr[:email]
			end

			it "should have a flash message" do
				flash[:success].should =~ /Данные успешно обновлены/
			end


		end
	end


	#===================================================================
	describe "authentication of edit/update pages" do
		before(:each) do
			@user = Factory :user
		end

		describe "for non-signed-in user" do

			it "should deny access to 'edit'" do
				get :edit, :id => @user
				response.should redirect_to(signin_path)
			end


			it "should deny access to 'edit'" do
				put :update, :id => @user, :user => {}
				response.should redirect_to(signin_path)
			end

		end

		describe "for other signed-in user" do

			before(:each) do
				wrong_user = Factory :user, :email=>'other_user@mail.com'
				test_sign_in wrong_user
			end

			it "should deny access to 'edit'" do
				get :edit, :id => @user
				response.should redirect_to(root_path)
			end


			it "should deny access to 'edit'" do
				put :update, :id => @user, :user => {}
				response.should redirect_to(root_path)
			end

		end


	end

	#=======================================================================
	describe "GET 'index'" do
		describe "for non-signed-in users" do
			it "should deny access" do
				get :index
				response.should redirect_to(signin_path)
			end
		end

		describe "for signed-in users" do
			before(:each) do
				@user 		= test_sign_in(Factory(:user))
				second_user = Factory(:user,
						  :name=>'secouseroid',
						  :email=>'arli@do.com',
						  )
				third_user = Factory(:user,
							:name=>'sadfasdf',
							:email=>'domgo@do.com',
							)
				@users = [@user, second_user, third_user]

				30.times do
					@users << Factory(:user, :email => Factory.next(:email))
				end

			end

			it "should have a rigth title" do
				get :index
				response.should have_selector('title',
						:content=>"Список пользователей")

			end

			it "should be successful" do
				get :index
				response.should be_success
			end

			it "should get name of users" do
				get :index
				@users[0..2].each  do |usr|
					response.should have_selector('li', :content=>usr.name)
				end
			end

			it "should paginate users" do
        		get :index
        		response.should have_selector("div.pagination")
        		response.should have_selector("span.disabled", :content => "Previous")
        		response.should have_selector("a", :content => "2")
        		response.should have_selector("a", :content => "Next")
      		end

		end

	end







end
