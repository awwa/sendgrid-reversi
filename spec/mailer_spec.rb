# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Mailer" do

  describe "send_message" do
    it "メッセージメール送信検査" do
      mailer = Mailer.new
      mailer.send_message("awwa500@gmail.com", "メールアドレスが識別できません。")
    end
  end

  describe "send_board" do
    it "ボードメール送信検査" do
      game = Game.new
      game.player_even = "awwa501@gmail.com"
      game.player_odd = "awwa500@gmail.com"
      game.turn = 3
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")

      mailer = Mailer.new
      mailer.send(game)
    end
  end
end
