require 'dotenv'

class Settings

  attr_accessor :username, :password, :parse_address, :app_host

  def initialize(file=nil)
    if file == nil
      config = Dotenv.load
    else
      config = Dotenv.overload(file)
    end
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @parse_address = ENV["PARSE_ADDRESS"]
    @app_host = ENV["APP_HOST"]
  end

end
