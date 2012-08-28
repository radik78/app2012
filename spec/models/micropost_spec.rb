require 'spec_helper'

describe Micropost do
	before(:each) do
		@user = Factory(:user) # пользователь, который будет иметь micropost
		@attr = { :content => "value for content"}		# содержимое misropost
	end

	it "should create a new instance given valid attributes" do
		@user.microposts.create!(@attr)
	end

	describe "user associations" do

		before(:each) do
			@micropost = @user.microposts.create(@attr)
		end

		it "shold have a user attribute" do
			@micropost.should respond_to(:user)
		end

		it "should have the right associated user" do
			@micropost.user_id.should == @user.id
			@micropost.user.should == @user
		end

	end

end
