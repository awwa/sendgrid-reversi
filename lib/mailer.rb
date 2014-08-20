# -*- encoding: utf-8 -*-

require 'sendgrid_ruby'
require 'sendgrid_ruby/version'
require 'sendgrid_ruby/email'
require 'logger'

class Mailer

  SUBJECT = "SendGrid Reversi"

  def initialize
    @logger = Logger.new(STDOUT)
    @settings = Settings.new
    dba = AppConfigCollection.new
    @app_config = dba.find_one
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
    email.set_from("game@" + @settings.parse_host)
    email.set_subject(SUBJECT)
    email.set_text(message)
    email.set_html(message)
    email.add_filter("templates", "enabled", 1)
    email.add_filter("templates", "template_id", @app_config.template_id_message)
    sendgrid = SendgridRuby::Sendgrid.new(@settings.sendgrid_username, @settings.sendgrid_password)
    response = sendgrid.send(email)
    @logger.info "send_message: #{to}"
  end

  def send_board(to, game)
    # prepare game data
    prep = game.to_prepared(@settings.app_url)

    # send email
    email = SendgridRuby::Email.new
    email.add_to(to)
    email.set_from("game@" + @settings.parse_host)
    email.set_subject(SUBJECT)
    email.set_text(" ")
    email.set_html(" ")
    for row in 0..7 do
      for col in 0..7 do
        email.add_substitution("#b#{row}#{col}#", [prep.board[row][col]])
      end
    end
    email.add_substitution("#pass_url#", [prep.pass_url])
    email.add_substitution("#count_b#", [game.get_count[:b]])
    email.add_substitution("#count_w#", [game.get_count[:w]])
    if game.turn % 2 == 0 then
      name_b = "#{game.player_odd}"
      name_w = "You"
    end
    if game.turn % 2 == 1 then
      name_b = "You"
      name_w = "#{game.player_even}"
    end
    email.add_substitution("#name_b#", [name_b])
    email.add_substitution("#name_w#", [name_w])
    email.add_substitution("#b#", [game.get_img_tag(@settings.app_url, "b.png")])
    email.add_substitution("#w#", [game.get_img_tag(@settings.app_url, "w.png")])
    email.add_substitution("#h_finish#", [game.is_finish ? "<p style='width: 90%; background-color: #ff0000; color: #ffffff; padding: 1%;'>勝負あり</p>" : ""])

    # for plain text template
    email.add_substitution("#p_finish#", [game.is_finish ? "勝負あり" : ""])
    email.add_substitution("#pb#", ["●"])
    email.add_substitution("#pw#", ["○"])
    for row in 0..7 do
      for col in 0..7 do
        email.add_substitution("#p#{row}#{col}#", [prep.p_board[row][col]])
      end
    end
    links = ""
    prep.p_links.each {|key, value|
      links = links + key + " " + value + "\r\n"
    }
    email.add_substitution("#links#", [links])

    email.add_filter("templates", "enabled", 1)
    email.add_filter("templates", "template_id", @app_config.template_id_board)
    sendgrid = SendgridRuby::Sendgrid.new(@settings.sendgrid_username, @settings.sendgrid_password)
    response = sendgrid.send(email)
    @logger.info "send_board: #{to}"
  end
end
