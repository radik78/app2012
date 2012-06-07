# coding: utf-8

require 'spec_helper'

describe "Friendly Forwardings: " do

	before (:each) do
		@user = Factory (:user)			# создали пользователя
		visit edit_user_path(@user)		# пытаемся перейти на
		# страницу редактирования
		# но так как пользователь не аутентефицировался, то
		# при помощи фильтра authenticate попадаем на
		# аутентификации signin_path
	end



    it "при попытке открытия стрницы редактирования
		 неаутентифицированным пользователем должна
		 открываться страница аутентификации" do

		response.should render_template ("new")
    end




    it "после успешной аутентификации переход на первоначально
		запрошенную страницу" do

		fill_in :email, :with =>@user.email
		fill_in :password, :with => @user.password
		click_button
		# пользователь должен пройти аутентификацию
		# response.should render_template (edit_user_path(@user))
		# response.should render_template (root_path)
		response.should render_template ("users/edit")
    end

end
