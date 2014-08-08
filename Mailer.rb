require 'sendgrid_ruby'
require 'sendgrid_ruby/version'
require 'sendgrid_ruby/email'
require 'dotenv'

class Mailer

  SUBJECT = "SendGrid Reversi"

  def initialize
    config = Dotenv.load
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @parse_address = ENV["PARSE_ADDRESS"]
  end

  def send(game)

    # turn==1の場合、player_evenには受け付け完了メール送信
    if game.turn == 1 then
      send_message(game.player_even, "対戦リクエストを受け付けました。しばらくお待ちください。")
    end

    # turn>1の場合、セッションレコードを元に各プレイヤーに応答メール送信
    if game.turn >= 1 then
      send_board(game)
    end

  end

  def send_message(to, message)
    begin
      email = SendgridRuby::Email.new
      email.add_to(to)
      email.set_from(@parse_address)
      email.set_subject(SUBJECT)
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

  def send_board(game)
    begin
      # prepare game data
      prep = game.to_prepared

      # send email
      email = SendgridRuby::Email.new
      if (game.turn % 2) == 0 then
        recip = game.player_even
      else
        recip = game.player_odd
      end
      puts "recip: #{recip}"
      email.add_to(recip)
      email.set_from(@parse_address)
      email.set_subject(SUBJECT)
      email.set_text(" ")
      email.set_html(" ")
      for row in 0..7 do
        for col in 0..7 do
          email.add_substitution("#b#{row}#{col}#", [prep.board[row][col]])
        end
      end
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
