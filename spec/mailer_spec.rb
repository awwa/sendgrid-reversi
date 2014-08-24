# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Mailer" do

  before :all do
    config = Dotenv.overload(".env.spec")
  end

  describe "send" do
    it "Validate send email" do
      begin
        game = Game.new
        game.player_even = ENV["PLAYER1"]
        game.player_odd = ENV["PLAYER2"]
        game.turn = 3
        game.board[0][0] = :w
        game.board[0][1] = :b
        game.history.push("b_0_1")

        mailer = Mailer.new
        mailer.send(game)
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

  describe "send_message" do
    it "Validate send message email" do
      begin
        mailer = Mailer.new
        mailer.send_message(ENV["PLAYER1"], "This is the test mail.")
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

  describe "send_board" do
    it "Validate send board email which game is not over" do
      begin
        game = Game.new
        game.player_even = ENV["PLAYER1"]
        game.player_odd = ENV["PLAYER2"]
        game.turn = 1
        game.board[0][0] = :w
        game.board[0][1] = :b
        game.history.push("b_0_1")

        mailer = Mailer.new
        mailer.send_board(game.player_even, game)
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end

    it "Validate send board email which game is over" do
      begin
        game = Game.new
        game.player_even = ENV["PLAYER1"]
        game.player_odd = ENV["PLAYER2"]
        game.turn = 1
        game.board[0][0] = :w
        game.board[0][1] = :b
        game.history.push("b_0_1")
        game.history.push("pass")
        game.history.push("pass")

        mailer = Mailer.new
        mailer.send_board(game.player_even, game)
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end

  end
end
