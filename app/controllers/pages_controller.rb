# coding: utf-8

class PagesController < ApplicationController
  def home
    @title = "Главная" 
  end
 
  def contact
    @title = "Наши контакты"
  end	

  def about
    @title = "О проекте"
  end

  def help
    @title = "Помощь"
  end

end
