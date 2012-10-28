# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

class User < ActiveRecord::Base

	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation, :encrypted_password

	has_many :microposts

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,
		:presence    => true,
		:length      => { :maximum => 50 }

  	validates :email,
		:presence    => true,
		:format      => { :with => email_regex },
		:uniqueness  => { :case_sensitive => false}


	# Automatically create the virtual attribute 'password_confirmation'.
	validates :password,	:presence     => true,
							:confirmation => true,
							:length       => { :within => 6..40 }

	before_save :make_encrypt_password

		def identical_password?(submitted_password)
			encrypted_password == encrypt_algoritm(submitted_password)
		end

		def self.identificate (email, password)
		#	finded_user = self.find_by_email(email)
		#	correct_passw = finded_user.identical_password?(password)
		#	if(finded_user && correct_passw)
		#		return (finded_user)
		#	else
		#		return (nil)
		#	end

			user = find_by_email(email)
			return nil  if user.nil?
			return user if user.identical_password?(password)

		end
		






  		def self.authenticate_with_salt(id, cookie_salt)
    		user = find_by_id(id)
    		(user && user.salt == cookie_salt) ? user : nil
  		end


	private



		def encrypt_algoritm(string)
			Digest::SHA2.hexdigest("#{string}--#{salt}")
		end


		def make_encrypt_password
			self.salt = Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}") if new_record?
			self.encrypted_password = encrypt_algoritm(password)
		end


end
