# -*- encoding: utf-8 -*-

require 'dotenv'

class Settings

  attr_accessor :username, :password, :app_url, :parse_host

  def initialize(file=nil)
    if file == nil
      config = Dotenv.load
    else
      config = Dotenv.overload(file)
    end
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @app_url = ENV["APP_URL"]
    @parse_host = ENV["PARSE_HOST"]
  end

end
