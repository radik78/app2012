# coding: utf-8

class UsersController < ApplicationController

    def show
		@user = User.find(params[:id])
        @title = @user.name
    end


    def new
		@user = User.new
        @title = 'Регистрация'
    end

	def create
		@user = User.new params[:user]
		if @user.save
			flash[:success] = "Добро пожаловать на наш сайт!"
			sign_in @user
			redirect_to @user
		else
			@title = 'Регистрация'
			render :new
		end
	end


end
