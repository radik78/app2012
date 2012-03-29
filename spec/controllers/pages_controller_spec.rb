# coding: utf-8

require 'spec_helper'

describe PagesController do

  render_views

  before(:each) do
     @base_title = "Ruby on Rails Tutorial Sample App"
  end

  #--------------------------------------------
  describe "GET 'home'" do

    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the rigth title" do
       get 'home'
         response.should have_selector("title", 
                    :content => @base_title+" | Главная")
    end

  end

    

  #--------------------------------------------
  describe "GET 'contact'" do

    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the rigth title" do
       get 'contact'
         response.should have_selector("title", 
                    :content => @base_title+" | Наши контакты")
            #         :content => "Contact") 
    end

  end

  #--------------------------------------------
  describe "GET 'about'" do

    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the rigth title" do
       get 'about'
         response.should have_selector("title", 
                    :content => @base_title+" | О проекте")
    end

  end

  #--------------------------------------------
  describe "GET 'help'" do

    it "should be successful" do
      get 'help'
      response.should be_success
    end
    
    it "should have the rigth title" do
       get 'help'
         response.should have_selector("title", 
                    :content => "Ruby on Rails Tutorial Sample App | Помощь")
    end

  end

  #--------------------------------------------

end
