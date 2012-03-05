class UsersController < ApplicationController

    def show
        @title = 'personal page'
		@user = User.find(params[:id])
    end


    def new
        @title = 'Sign up'
    end


end
