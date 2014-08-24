# -*- encoding: utf-8 -*-

require 'dotenv'

class Settings

  attr_accessor :sendgrid_username, :sendgrid_password, :app_url, :parse_host, :mongo_host, :mongo_port, :mongo_db, :mongo_username, :mongo_password

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
    @mongo_host = ENV["MONGO_HOST"]
    @mongo_port = ENV["MONGO_PORT"]
    @mongo_db = ENV["MONGO_DB"]
    @mongo_username = ENV["MONGO_USERNAME"]
    @mongo_password = ENV["MONGO_PASSWORD"]
  end

end
