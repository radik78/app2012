# coding: utf-8

class SessionsController < ApplicationController




  #----------------- new --------------------------------------------------------


  def new
	@title = 'Вход'
  end




  #----------------- create --------------------------------------------------------


 def create

	user = User.identificate(params[:session][:email],
		                     params[:session][:password])
	if user.nil?
		flash.now[:error] = "Некорректная комбинация email/password"
		@title = 'Вход'
      	render 'new'
	else
		# Sign the user in and redirect to the user's show page.
		flash[:success] = "Успешный вход на сайт"
		sign_in user

      	redirect_to (session[:desire_path] || user)


#		redirect_to (session[:desire_path])
		session[:desire_path] = nil
	end

 end



  #----------------- destroy --------------------------------------------------------

  def destroy
	sign_out
	redirect_to root_path
  end




end
