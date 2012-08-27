# coding: utf-8



class UsersController < ApplicationController

	before_filter :authenticate,	 :only => [:edit, :update, :index, :destroy]
	before_filter :correct_user_id,	 :only => [:edit, :update]
	before_filter :admin_user,		 :only => :destroy
	before_filter :non_authenticate, :only => [:new, :create]
	before_filter :delete_himself,   :only => [:destroy]


	#-------------------------------------------------------
    def show
		@user = User.find(params[:id])
        @title = @user.name
	end

	#-------------------------------------------------------
    def new
		@user = User.new
        @title = 'Регистрация'
    end

	#-------------------------------------------------------
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

	#-------------------------------------------------------
	def edit
		@user = User.find(params[:id])
        @title = "Редактирование"
	end

	#-------------------------------------------------------
	def destroy
		deleting_user = User.find(params[:id])
		deleting_user.destroy
		flash[:success] = "User with name #{deleting_user.name} is destroyed."
		redirect_to users_path
	end

	#-------------------------------------------------------
	def update
		@user = User.find(params[:id])

        if @user.update_attributes params[:user]
			flash[:success]	= 'Данные успешно обновлены'
			redirect_to user_path(@user)
		else
			@title = 'Редактирование'
			render 'edit'
		end

	end

	#-------------------------------------------------------
	def index
		@title = 'Список пользователей'
		@users = User.paginate(:page => params[:page])
	end


	#-------------------------------------------------------
	#-------------------------------------------------------

	private

hh

		# ============= фильтры ======================

		def authenticate
			deny_access unless signed_in?
		end

		def non_authenticate
			deny_access if signed_in?
		end



		def correct_user_id
			querry_user = User.find(params[:id])
			redirect_to root_path unless current_user? querry_user
		end


		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

		def delete_himself
			querry_user = User.find(params[:id])
			redirect_to root_path if current_user? querry_user
		end

end
