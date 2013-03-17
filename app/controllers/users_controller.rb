require 'nokogiri'
require 'open-uri'

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to login_path,
        :notice => t("flash.signup.create.notice")
    else
      render :new
    end
  end

  def show
    begin
      @user = User.find(params[:id])
      @talks = @user.talks.where(:to_public => true).order_by(:created_at => "DESC").entries

      profile = Gravatar.profile(@user.email)

      begin
        xml = Nokogiri::XML(open("#{profile}.xml"))

        @profile_url = xml.xpath("//profileUrl").text
        @about_me = xml.xpath("//aboutMe").text
        @current_location = xml.xpath("//currentLocation").text
        @emails = xml.xpath("//emails/value")
        @tem_perfil_no_gravatar = true
      rescue OpenURI::HTTPError
        @tem_perfil_no_gravatar = false
      end
    rescue Mongoid::Errors::DocumentNotFound
      redirect_to root_path, :notice => t("flash.user_not_found")
    end
  end
end