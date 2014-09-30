# -*- encoding: utf-8 -*-

require 'dotenv'

class Settings

  attr_accessor :sendgrid_username, :sendgrid_password, :app_url, :parse_host, :mongo_url

  def initialize(file=nil)
    if file == nil
      config = Dotenv.load
    else
      config = Dotenv.overload(file)
    end
    @sendgrid_username = ENV["SENDGRID_USERNAME"]
    @sendgrid_password = ENV["SENDGRID_PASSWORD"]
    @app_url = ENV["APP_URL"]
    @parse_host = ENV["PARSE_HOST"]
    @mongo_url = ENV["MONGO_URL"] || ENV["MONGOHQ_URL"]
  end

end
