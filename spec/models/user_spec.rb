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

require 'spec_helper'

describe User do

	#--------------------------------------------------------------------------------

	before(:each) do
		@attr = {
			 :name => "Example User",
			 :email => "user@example.com",
			 :password => "foobar",
			 :password_confirmation => "foobar"
		}
	end


 	#--------------------------------------------------------------------------------

	describe "name and email validation" do
		it "should create a new instance given valid attributes" do
			User.create!(@attr)
		end



		it "should reject names that are too long" do
			long_name = "a" * 51
			long_name_user = User.new(@attr.merge(:name => long_name))
			long_name_user.should_not be_valid
		end

		it "should reject with duplicate email" do
			User.create!(@attr)
			upcase_email = @attr[:email].upcase
			user_duplicate = User.new(@attr.merge(:email=>upcase_email))
			user_duplicate.should_not be_valid
		end
	end


	#--------------------------------------------------------------------------------


	describe "password validation" do

		it "should require a password" do
			User.new(@attr.merge(:password => "", :password_confirmation => "")).
			should_not be_valid
		end

		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).
			should_not be_valid
		end

		it "should reject short passwords" do
			short = "a" * 5
			hash = @attr.merge(:password => short, :password_confirmation => short)
			User.new(hash).should_not be_valid
		end

		it "should reject long passwords" do
			long = "a" * 41
			hash = @attr.merge(:password => long, :password_confirmation => long)
			User.new(hash).should_not be_valid
		end

	end


	#-----------------------------------------------------------------------------
	describe "password encryption" do

		before(:each) do
			@user = User.create!(@attr)
		end

		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end

		it "should get true on correct submitted password" do
			@user.identical_password?(@user.password).should be_true
		end


		it "should get false on incorrect submitted password" do
			@user.identical_password?(@user.password+" ").should be_false
		end


		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end

		describe "identificate method" do

			it "should return object user on correct email and correct password" do
				(User.identificate(@attr[:email], @attr[:password])==@user).should be_true
			end

			it "should return nil on incorrect email" do
				User.identificate("nonexist@com", @attr[:password]).should be_nil
			end

			it "should return nil on incorrect password" do
				User.identificate(@attr[:email], "bad_pass").should be_nil
			end


		end

	end
	#-----------------------------------------------------------------------------


	describe "admin attribute" do

		# создадим пользователя в базе данных и сохраним в глобальной переменной
		before(:each) do
			@user = User.create!(@attr)
		end

		# экземпляр класса должен иметь свойство админ
		it "should respond to admin" do
			@user.should respond_to(:admin)
		end

		# свойство админ экзепляра класса должно по умолчанию возвращать ложь
		it "should not be an admin by default" do
			@user.should_not be_admin
		end

		# свойство админ должно свободно конветироваться
		it "should be convertible to an admin" do
			@user.toggle!(:admin)
			@user.should be_admin
		end
	end


	#==================  ассоциации с micropost ===================


	describe 'micropost associations' do
		before(:each) do
			@user = User.create(@attr)
			@mp_hour_ago = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
			@mp_day_ago = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
		end

		it "should have a microposts attribute" do
			@user.should respond_to(:microposts)
		end

		#it "should have a the right microposts in the right order" do
		#	@user.microposts.should  = [@mp_hour_ago,@mp_day_ago]
		#end

		it


	end






end
