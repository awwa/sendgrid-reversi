require 'sendgrid_ruby'
require 'sendgrid_ruby/version'
require 'sendgrid_ruby/email'
require 'dotenv'
require 'logger'

class Mailer

  SUBJECT = "SendGrid Reversi"

  def initialize
    @logger = Logger.new(STDOUT)
    config = Dotenv.load
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @parse_address = ENV["PARSE_ADDRESS"]
  end

  def send(game)
    # Decide recipient
    if (game.turn % 2) == 0 then
      turn_player = game.player_even
      wait_player = game.player_odd
    else
      turn_player = game.player_odd
      wait_player = game.player_even
    end
    @logger.info "turn_player: #{turn_player}"
    @logger.info "wait_player: #{wait_player}"

    # Send board mail for turn player
    send_board(turn_player, game)

    # Send accept mail for wait player
    if game.turn == 1 then
      send_message(wait_player, "対戦リクエストを受け付けました。しばらくお待ちください。")
    else
      send_message(wait_player, "相手プレイヤーに催促通知を送信しました。しばらくお待ちください。")
    end
  end

  def send_message(to, message)
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
    @logger.info "send_message: #{to}"
  end

  def send_board(to, game)
    # prepare game data
    prep = game.to_prepared(ENV["APP_HOST"])

    # send email
    email = SendgridRuby::Email.new
    email.add_to(to)
    email.set_from(@parse_address)
    email.set_subject(SUBJECT)
    email.set_text(" ")
    email.set_html(" ")
    for row in 0..7 do
      for col in 0..7 do
        email.add_substitution("#b#{row}#{col}#", [prep.board[row][col]])
      end
    end
    email.add_substitution("#pass_url#", [prep.pass_url])
    email.add_filter("templates", "enabled", 1)
    email.add_filter("templates", "template_id", ENV["TEMP_ID_REVERSI"])
    sendgrid = SendgridRuby::Sendgrid.new(@username, @password)
    response = sendgrid.send(email)
    @logger.info "send_board: #{to}"
  end
end
