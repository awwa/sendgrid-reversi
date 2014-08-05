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

  describe "to_prepared" do
    it "準備検査" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")

      prep = game.to_prepared
      prep.player_even.should == "even@address.com"
      prep.player_odd.should == "odd@address.com"
      prep.turn.should == 100
      prep.board[0][0].should == "<img src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/w.png'>"
      prep.board[0][1].should == "<img src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/b.png'>"
      prep.board[0][2][0,7].should == "<a href"
      prep.board[3][3].should == "<img src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/w.png'>"
      prep.board[3][4].should == "<img src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/b.png'>"
    end
  end

  describe "check_loop" do

    #  0 1 2 3 4 5 6 7
    #0 w b *
    #1
    #2
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置ける場所であることの検査1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(0, 2,-1, 0).should == false  # 上
      game.check_loop(0, 2,-1, 1).should == false  # 上右
      game.check_loop(0, 2, 0, 1).should == false  # 　右
      game.check_loop(0, 2, 1, 1).should == false  # 下右
      game.check_loop(0, 2, 1, 0).should == false  # 下
      game.check_loop(0, 2, 1,-1).should == false  # 下左
      game.check_loop(0, 2, 0,-1).should == true  # 　左
      game.check_loop(0, 2,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2       *
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置けない場所であることの検査1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(2, 3,-1, 0).should == false  # 上
      game.check_loop(2, 3,-1, 1).should == false  # 上右
      game.check_loop(2, 3, 0, 1).should == false  # 　右
      game.check_loop(2, 3, 1, 1).should == false  # 下右
      game.check_loop(2, 3, 1, 0).should == false  # 下
      game.check_loop(2, 3, 1,-1).should == false  # 下左
      game.check_loop(2, 3, 0,-1).should == false  # 　左
      game.check_loop(2, 3,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2         *
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置ける場所であることの検査1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(2, 4,-1, 0).should == false  # 上
      game.check_loop(2, 4,-1, 1).should == false  # 上右
      game.check_loop(2, 4, 0, 1).should == false  # 　右
      game.check_loop(2, 4, 1, 1).should == false  # 下右
      game.check_loop(2, 4, 1, 0).should == true  # 下
      game.check_loop(2, 4, 1,-1).should == false  # 下左
      game.check_loop(2, 4, 0,-1).should == false  # 　左
      game.check_loop(2, 4,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2           *
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置けない場所であることの検査2" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(2, 5,-1, 0).should == false  # 上
      game.check_loop(2, 5,-1, 1).should == false  # 上右
      game.check_loop(2, 5, 0, 1).should == false  # 　右
      game.check_loop(2, 5, 1, 1).should == false  # 下右
      game.check_loop(2, 5, 1, 0).should == false  # 下
      game.check_loop(2, 5, 1,-1).should == false  # 下左
      game.check_loop(2, 5, 0,-1).should == false  # 　左
      game.check_loop(2, 5,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b *
    #1
    #2
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置ける場所であることの検査1" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(0, 2,-1, 0).should == false  # 上
      game.check_loop(0, 2,-1, 1).should == false  # 上右
      game.check_loop(0, 2, 0, 1).should == false  # 　右
      game.check_loop(0, 2, 1, 1).should == false  # 下右
      game.check_loop(0, 2, 1, 0).should == false  # 下
      game.check_loop(0, 2, 1,-1).should == false  # 下左
      game.check_loop(0, 2, 0,-1).should == false  # 　左
      game.check_loop(0, 2,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2       *
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置けない場所であることの検査1" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(2, 3,-1, 0).should == false  # 上
      game.check_loop(2, 3,-1, 1).should == false  # 上右
      game.check_loop(2, 3, 0, 1).should == false  # 　右
      game.check_loop(2, 3, 1, 1).should == false  # 下右
      game.check_loop(2, 3, 1, 0).should == true  # 下
      game.check_loop(2, 3, 1,-1).should == false  # 下左
      game.check_loop(2, 3, 0,-1).should == false  # 　左
      game.check_loop(2, 3,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2         *
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置ける場所であることの検査1" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(2, 4,-1, 0).should == false  # 上
      game.check_loop(2, 4,-1, 1).should == false  # 上右
      game.check_loop(2, 4, 0, 1).should == false  # 　右
      game.check_loop(2, 4, 1, 1).should == false  # 下右
      game.check_loop(2, 4, 1, 0).should == false  # 下
      game.check_loop(2, 4, 1,-1).should == false  # 下左
      game.check_loop(2, 4, 0,-1).should == false  # 　左
      game.check_loop(2, 4,-1,-1).should == false  # 上左
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2           *
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "石を置けない場所であることの検査2" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      game.check_loop(2, 5,-1, 0).should == false  # 上
      game.check_loop(2, 5,-1, 1).should == false  # 上右
      game.check_loop(2, 5, 0, 1).should == false  # 　右
      game.check_loop(2, 5, 1, 1).should == false  # 下右
      game.check_loop(2, 5, 1, 0).should == false  # 下
      game.check_loop(2, 5, 1,-1).should == false  # 下左
      game.check_loop(2, 5, 0,-1).should == false  # 　左
      game.check_loop(2, 5,-1,-1).should == false  # 上左
    end

  end

  describe "check_available" do

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "白石を置ける場所であることの検査1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b



      game.check_available(0, 2).should == true
      game.check_available(0, 3).should == false
      game.check_available(0, 4).should == false
      game.check_available(0, 5).should == false
      game.check_available(0, 6).should == false
      game.check_available(0, 7).should == false

      game.check_available(1, 0).should == false
      game.check_available(1, 1).should == false
      game.check_available(1, 2).should == false
      game.check_available(1, 3).should == false
      game.check_available(1, 4).should == false
      game.check_available(1, 5).should == false
      game.check_available(1, 6).should == false
      game.check_available(1, 7).should == false

      game.check_available(2, 0).should == false
      game.check_available(2, 1).should == false
      game.check_available(2, 2).should == false
      game.check_available(2, 3).should == false
      game.check_available(2, 4).should == true
      game.check_available(2, 5).should == false
      game.check_available(2, 6).should == false
      game.check_available(2, 7).should == false

      game.check_available(3, 0).should == false
      game.check_available(3, 1).should == false
      game.check_available(3, 2).should == false
      #game.check_available(3, 3).should == false
      #game.check_available(3, 4).should == true
      game.check_available(3, 5).should == true
      game.check_available(3, 6).should == false
      game.check_available(3, 7).should == false

      game.check_available(4, 0).should == false
      game.check_available(4, 1).should == false
      game.check_available(4, 2).should == true
      #game.check_available(4, 3).should == false
      #game.check_available(4, 4).should == true
      game.check_available(4, 5).should == false
      game.check_available(4, 6).should == false
      game.check_available(4, 7).should == false

      game.check_available(5, 0).should == false
      game.check_available(5, 1).should == false
      game.check_available(5, 2).should == false
      game.check_available(5, 3).should == true
      game.check_available(5, 4).should == false
      game.check_available(5, 5).should == false
      game.check_available(5, 6).should == false
      game.check_available(5, 7).should == false

      game.check_available(6, 0).should == false
      game.check_available(6, 1).should == false
      game.check_available(6, 2).should == false
      game.check_available(6, 3).should == false
      game.check_available(6, 4).should == false
      game.check_available(6, 5).should == false
      game.check_available(6, 6).should == false
      game.check_available(6, 7).should == false

      game.check_available(7, 0).should == false
      game.check_available(7, 1).should == false
      game.check_available(7, 2).should == false
      game.check_available(7, 3).should == false
      game.check_available(7, 4).should == false
      game.check_available(7, 5).should == false
      game.check_available(7, 6).should == false
      game.check_available(7, 7).should == false
    end

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "黒石を置ける場所であることの検査1" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b



      game.check_available(0, 2).should == false
      game.check_available(0, 3).should == false
      game.check_available(0, 4).should == false
      game.check_available(0, 5).should == false
      game.check_available(0, 6).should == false
      game.check_available(0, 7).should == false

      game.check_available(1, 0).should == false
      game.check_available(1, 1).should == false
      game.check_available(1, 2).should == false
      game.check_available(1, 3).should == false
      game.check_available(1, 4).should == false
      game.check_available(1, 5).should == false
      game.check_available(1, 6).should == false
      game.check_available(1, 7).should == false

      game.check_available(2, 0).should == false
      game.check_available(2, 1).should == false
      game.check_available(2, 2).should == false
      game.check_available(2, 3).should == true
      game.check_available(2, 4).should == false
      game.check_available(2, 5).should == false
      game.check_available(2, 6).should == false
      game.check_available(2, 7).should == false

      game.check_available(3, 0).should == false
      game.check_available(3, 1).should == false
      game.check_available(3, 2).should == true
      #game.check_available(3, 3).should == false
      #game.check_available(3, 4).should == true
      game.check_available(3, 5).should == false
      game.check_available(3, 6).should == false
      game.check_available(3, 7).should == false

      game.check_available(4, 0).should == false
      game.check_available(4, 1).should == false
      game.check_available(4, 2).should == false
      #game.check_available(4, 3).should == false
      #game.check_available(4, 4).should == true
      game.check_available(4, 5).should == true
      game.check_available(4, 6).should == false
      game.check_available(4, 7).should == false

      game.check_available(5, 0).should == false
      game.check_available(5, 1).should == false
      game.check_available(5, 2).should == false
      game.check_available(5, 3).should == false
      game.check_available(5, 4).should == true
      game.check_available(5, 5).should == false
      game.check_available(5, 6).should == false
      game.check_available(5, 7).should == false

      game.check_available(6, 0).should == false
      game.check_available(6, 1).should == false
      game.check_available(6, 2).should == false
      game.check_available(6, 3).should == false
      game.check_available(6, 4).should == false
      game.check_available(6, 5).should == false
      game.check_available(6, 6).should == false
      game.check_available(6, 7).should == false

      game.check_available(7, 0).should == false
      game.check_available(7, 1).should == false
      game.check_available(7, 2).should == false
      game.check_available(7, 3).should == false
      game.check_available(7, 4).should == false
      game.check_available(7, 5).should == false
      game.check_available(7, 6).should == false
      game.check_available(7, 7).should == false
    end

  end

end
