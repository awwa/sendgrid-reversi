# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Mailer" do

  describe "send" do
    it "Validate send email" do
      begin
        game = Game.new
        game.player_even = "wataru@kke.co.jp"
        game.player_odd = "awwa500@gmail.com"
        game.turn = 3
        game.board[0][0] = :w
        game.board[0][1] = :b
        game.history.push("b_0_1")

        mailer = Mailer.new
        mailer.send(game)
      rescue => e
        puts e.inspect
      end
    end
  end

  describe "send_message" do
    it "Validate send message email" do
      begin
        mailer = Mailer.new
        mailer.send_message("awwa500@gmail.com", "This is the test mail.")
      rescue => e
        puts e.inspect
      end
    end
  end

  describe "send_board" do
    it "Validate send board email which game is not over" do
      settings = Settings.new
      Configure.init_sendgrid(settings)

      game = Game.new
      game.player_even = "wataru@kke.co.jp"
      game.player_odd = "awwa500@gmail.com"
      game.turn = 1
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")

      mailer = Mailer.new
      mailer.send_board(game.player_even, game)
    end

    it "Validate send board email which game is over" do
      settings = Settings.new
      Configure.init_sendgrid(settings)

      game = Game.new
      game.player_even = "wataru@kke.co.jp"
      game.player_odd = "awwa500@gmail.com"
      game.turn = 1
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")
      game.history.push("pass")
      game.history.push("pass")

      mailer = Mailer.new
      mailer.send_board(game.player_even, game)
    end

  end
end
