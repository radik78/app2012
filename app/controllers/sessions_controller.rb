class SessionsController < ApplicationController
  



  #----------------- new --------------------------------------------------------


  def new
	@title = 'Sign in'
  end




  #----------------- create --------------------------------------------------------


 def create

	user = User.identificate(params[:session][:email],
		                     params[:session][:password])
	if user.nil?

		flash[:test] = 0
		flash.now[:error] = "Invalid email/password combination."
		@title = 'Sign in'
      	render 'new'
	else
		flash[:test] = 1
		# Sign the user in and redirect to the user's show page.
		flash[:success] = "Correct Sign In!"
		sign_in user
      	redirect_to user
	end

 end



  #----------------- destroy --------------------------------------------------------

  def destroy
	sign_out
	redirect_to root_path
  end




end
