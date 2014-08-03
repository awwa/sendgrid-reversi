# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Game" do
  describe "initialize" do
    it "初期値検査" do
      game = Game.new
      game.player_even.should == ""
      game.player_odd.should == ""
      game.turn.should == 1
      game.board[0][0].should == nil
      game.board[7][7].should == nil
      game.board[3][3].should == :w
      game.board[3][4].should == :b
      game.board[4][3].should == :b
      game.board[4][4].should == :w
      game.board.length.should == 8
      game.board[0].length.should == 8
      game.history.length.should == 0
    end
  end

  describe "to_array" do
    it "ハッシュ検査" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")

      actual = game.to_array
      actual["player_even"].should == "even@address.com"
      actual["player_odd"].should == "odd@address.com"
      actual["turn"].should == 100
      actual["board"][0][0].should == :w
      actual["board"][0][1].should == :b
      actual["history"][0].should == "b_0_1"
    end
  end
end
