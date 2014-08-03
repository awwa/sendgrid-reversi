require 'sendgrid_ruby'
require 'sendgrid_ruby/version'
require 'sendgrid_ruby/email'
require 'dotenv'

class Mailer

  def initialize
    config = Dotenv.load
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @parse_address = ENV["PARSE_ADDRESS"]
  end

  def send_message(to, message)
    begin
      email = SendgridRuby::Email.new
      email.add_to(to)
      email.set_from(@parse_address)
      email.set_subject("SendGrid Reversi")
      email.set_text(message)
      email.set_html(message)
      email.add_filter("templates", "enabled", 1)
      email.add_filter("templates", "template_id", ENV["TEMP_ID_MESSAGE"])

      sendgrid = SendgridRuby::Sendgrid.new(@username, @password)
      response = sendgrid.send(email)
    rescue => e
      puts e.inspect
      raise e
    end
  end

  def send(to, plain, html)
    begin
      email = SendgridRuby::Email.new
      email.add_to(to)
      email.set_from(@parse_address)
      email.set_subject("test")
      email.set_text(plain)
      email.set_html(html)
      email.add_substitution("#aaa#", ["Yo!"])
      email.add_filter("templates", "enabled", 1)
      email.add_filter("templates", "template_id", ENV["TEMP_ID_REVERSI"])

      sendgrid = SendgridRuby::Sendgrid.new(@username, @password)
      response = sendgrid.send(email)
    rescue => e
      puts e.inspect
      raise e
    end



  end

end
