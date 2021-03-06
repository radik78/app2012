#coding: utf-8
module SessionsHelper


	attr_accessor :current_user


	def signed_in?
    	!self.current_user.nil?
  	end


	def sign_in(user)
		#cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		session[:remember_token] = [user.id, user.salt]
		self.current_user = user
	end



	def sign_out
    	#cookies.delete(:remember_token)		# удаляем куки "remember_token"
		session[:remember_token] = nil
    	self.current_user = nil				# локальная переменная = nil
	end


	def deny_access
		session[:desire_path] = request.fullpath
		redirect_to signin_path, :notice => "Пожалуйста, совершите вход для доступа к запрашиваемой странице"
	end

	def current_user? (user)
		user==current_user
	end

	def current_user
	    @current_user ||= user_from_remember_token
	end

  	private

		def user_from_remember_token
		  User.authenticate_with_salt(*remember_token)
		end

		def remember_token
		  session[:remember_token]  || [nil, nil]
		  #cookies.signed[:remember_token] || [nil, nil]
		end


end
