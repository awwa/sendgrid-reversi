# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Game" do
  describe "initialize" do
    it "Validate constructor" do
      game = Game.new
      expect(game.player_even).to eq("")
      expect(game.player_odd).to eq("")
      expect(game.turn).to eq(1)
      expect(game.board[0][0]).to eq(nil)
      expect(game.board[7][7]).to eq(nil)
      expect(game.board[3][3]).to eq(:w)
      expect(game.board[3][4]).to eq(:b)
      expect(game.board[4][3]).to eq(:b)
      expect(game.board[4][4]).to eq(:w)
      expect(game.board.length).to eq(8)
      expect(game.board[0].length).to eq(8)
      expect(game.history.length).to eq(0)
    end
  end

  describe "to_array" do
    it "Validate get hash" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")

      actual = game.to_array
      expect(actual["player_even"]).to eq("even@address.com")
      expect(actual["player_odd"]).to eq("odd@address.com")
      expect(actual["turn"]).to eq(100)
      expect(actual["board"][0][0]).to eq(:w)
      expect(actual["board"][0][1]).to eq(:b)
      expect(actual["history"][0]).to eq("b_0_1")
    end
  end

  describe "generate_cell_url" do
    it "Validate create cell url" do
      expect(Game.generate_cell_url("https://test.com", "12345", 222, 4, 5)).to eq( "https://test.com/event?obj_id=12345&turn=222&row=4&col=5")
    end
    it "Validate pass url" do
      expect(Game.generate_cell_url("https://test.com", "12345", 222, -1, -1)).to eq( "https://test.com/event?obj_id=12345&turn=222&row=-1&col=-1")
    end
  end

  describe "parse_cell_url" do
    it "Validate parse cell url" do
      data = Game.parse_cell_url("https://test.com/event?obj_id=12345&turn=222&row=4&col=5")
      expect(data['obj_id']).to eq("12345")
      expect(data['turn']).to eq(222)
      expect(data['row']).to eq(4)
      expect(data['col']).to eq(5)
    end
  end

  describe "to_prepared" do
    it "Validate prepare" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b
      game.history.push("b_0_1")

      prep = game.to_prepared("http://test.com")
      expect(prep.player_even).to eq("even@address.com")
      expect(prep.player_odd).to eq("odd@address.com")
      expect(prep.turn).to eq(100)
      expect(prep.pass_url[0,29]).to eq("http://test.com/event?obj_id=")
      expect(prep.board[0][0]).to eq("<img style='width: 100%;' src='http://test.com/w.png'>")
      expect(prep.board[0][1]).to eq("<img style='width: 100%;' src='http://test.com/b.png'>")
      expect(prep.board[0][2][0,7]).to eq("<a href")
      expect(prep.board[0][3]).to eq("<img style='width: 100%;' src='http://test.com/n.png'>")
      expect(prep.board[3][3]).to eq("<img style='width: 100%;' src='http://test.com/w.png'>")
      expect(prep.board[3][4]).to eq("<img style='width: 100%;' src='http://test.com/b.png'>")
      expect(prep.p_links.length).to eq(5)
      expect(prep.p_links["C1"][0,7]).to eq("http://")
      expect(prep.p_links["E3"][0,7]).to eq("http://")
      expect(prep.p_links["F4"][0,7]).to eq("http://")
      expect(prep.p_links["C5"][0,7]).to eq("http://")
      expect(prep.p_links["D6"][0,7]).to eq("http://")
    end
  end

  describe "conv_plain_coord" do
    it "Validate tranform position for plain/text" do
      expect(Game.conv_plain_coord(1, 2)).to eq("C2")
    end
  end

  describe "is_available_dir" do

    #  0 1 2 3 4 5 6 7
    #0 w b *
    #1
    #2
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "Validate available 1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(0, 2, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::DOWN)).to       eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::LEFT)).to       eq(true)
      expect(game.is_available_dir(0, 2, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate unavailable 1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(2, 3, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::DOWN)).to       eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate available 2" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(2, 4, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::DOWN)).to       eq(true)
      expect(game.is_available_dir(2, 4, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate unavailable 2" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(2, 5, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::DOWN)).to       eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate unavailable 3" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(0, 2, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::DOWN)).to       eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(0, 2, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate available 3" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(2, 3, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::DOWN)).to       eq(true)
      expect(game.is_available_dir(2, 3, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(2, 3, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate unavailable 4" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(2, 4, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::DOWN)).to       eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(2, 4, Game::Dir::UP_LEFT)).to    eq(false)
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
    it "Validate unavailable 5" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_dir(2, 5, Game::Dir::UP)).to         eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::UP_RIGHT)).to   eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::RIGHT)).to      eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::DOWN_RIGHT)).to eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::DOWN)).to       eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::DOWN_LEFT)).to  eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::LEFT)).to       eq(false)
      expect(game.is_available_dir(2, 5, Game::Dir::UP_LEFT)).to    eq(false)
    end

  end

  describe "is_available_cell" do

    #  0 1 2 3 4 5 6 7
    #0 w b
    #1
    #2
    #3       w b
    #4       b w
    #5
    #6
    #7
    it "Validate available for black 1" do
      game = Game.new
      game.turn = 100
      game.board[0][0] = :w
      game.board[0][1] = :b

      expect(game.is_available_cell(0, 2)).to eq(true)
      expect(game.is_available_cell(0, 3)).to eq(false)
      expect(game.is_available_cell(0, 4)).to eq(false)
      expect(game.is_available_cell(0, 5)).to eq(false)
      expect(game.is_available_cell(0, 6)).to eq(false)
      expect(game.is_available_cell(0, 7)).to eq(false)

      expect(game.is_available_cell(1, 0)).to eq(false)
      expect(game.is_available_cell(1, 1)).to eq(false)
      expect(game.is_available_cell(1, 2)).to eq(false)
      expect(game.is_available_cell(1, 3)).to eq(false)
      expect(game.is_available_cell(1, 4)).to eq(false)
      expect(game.is_available_cell(1, 5)).to eq(false)
      expect(game.is_available_cell(1, 6)).to eq(false)
      expect(game.is_available_cell(1, 7)).to eq(false)

      expect(game.is_available_cell(2, 0)).to eq(false)
      expect(game.is_available_cell(2, 1)).to eq(false)
      expect(game.is_available_cell(2, 2)).to eq(false)
      expect(game.is_available_cell(2, 3)).to eq(false)
      expect(game.is_available_cell(2, 4)).to eq(true)
      expect(game.is_available_cell(2, 5)).to eq(false)
      expect(game.is_available_cell(2, 6)).to eq(false)
      expect(game.is_available_cell(2, 7)).to eq(false)

      expect(game.is_available_cell(3, 0)).to eq(false)
      expect(game.is_available_cell(3, 1)).to eq(false)
      expect(game.is_available_cell(3, 2)).to eq(false)
      #expect(game.is_available_cell(3, 3)).to eq(false)
      #expect(game.is_available_cell(3, 4)).to eq(true)
      expect(game.is_available_cell(3, 5)).to eq(true)
      expect(game.is_available_cell(3, 6)).to eq(false)
      expect(game.is_available_cell(3, 7)).to eq(false)

      expect(game.is_available_cell(4, 0)).to eq(false)
      expect(game.is_available_cell(4, 1)).to eq(false)
      expect(game.is_available_cell(4, 2)).to eq(true)
      #expect(game.is_available_cell(4, 3)).to eq(false)
      #expect(game.is_available_cell(4, 4)).to eq(true)
      expect(game.is_available_cell(4, 5)).to eq(false)
      expect(game.is_available_cell(4, 6)).to eq(false)
      expect(game.is_available_cell(4, 7)).to eq(false)

      expect(game.is_available_cell(5, 0)).to eq(false)
      expect(game.is_available_cell(5, 1)).to eq(false)
      expect(game.is_available_cell(5, 2)).to eq(false)
      expect(game.is_available_cell(5, 3)).to eq(true)
      expect(game.is_available_cell(5, 4)).to eq(false)
      expect(game.is_available_cell(5, 5)).to eq(false)
      expect(game.is_available_cell(5, 6)).to eq(false)
      expect(game.is_available_cell(5, 7)).to eq(false)

      expect(game.is_available_cell(6, 0)).to eq(false)
      expect(game.is_available_cell(6, 1)).to eq(false)
      expect(game.is_available_cell(6, 2)).to eq(false)
      expect(game.is_available_cell(6, 3)).to eq(false)
      expect(game.is_available_cell(6, 4)).to eq(false)
      expect(game.is_available_cell(6, 5)).to eq(false)
      expect(game.is_available_cell(6, 6)).to eq(false)
      expect(game.is_available_cell(6, 7)).to eq(false)

      expect(game.is_available_cell(7, 0)).to eq(false)
      expect(game.is_available_cell(7, 1)).to eq(false)
      expect(game.is_available_cell(7, 2)).to eq(false)
      expect(game.is_available_cell(7, 3)).to eq(false)
      expect(game.is_available_cell(7, 4)).to eq(false)
      expect(game.is_available_cell(7, 5)).to eq(false)
      expect(game.is_available_cell(7, 6)).to eq(false)
      expect(game.is_available_cell(7, 7)).to eq(false)
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
    it "Validate available for black 1" do
      game = Game.new
      game.turn = 101
      game.board[0][0] = :w
      game.board[0][1] = :b



      expect(game.is_available_cell(0, 2)).to eq(false)
      expect(game.is_available_cell(0, 3)).to eq(false)
      expect(game.is_available_cell(0, 4)).to eq(false)
      expect(game.is_available_cell(0, 5)).to eq(false)
      expect(game.is_available_cell(0, 6)).to eq(false)
      expect(game.is_available_cell(0, 7)).to eq(false)

      expect(game.is_available_cell(1, 0)).to eq(false)
      expect(game.is_available_cell(1, 1)).to eq(false)
      expect(game.is_available_cell(1, 2)).to eq(false)
      expect(game.is_available_cell(1, 3)).to eq(false)
      expect(game.is_available_cell(1, 4)).to eq(false)
      expect(game.is_available_cell(1, 5)).to eq(false)
      expect(game.is_available_cell(1, 6)).to eq(false)
      expect(game.is_available_cell(1, 7)).to eq(false)

      expect(game.is_available_cell(2, 0)).to eq(false)
      expect(game.is_available_cell(2, 1)).to eq(false)
      expect(game.is_available_cell(2, 2)).to eq(false)
      expect(game.is_available_cell(2, 3)).to eq(true)
      expect(game.is_available_cell(2, 4)).to eq(false)
      expect(game.is_available_cell(2, 5)).to eq(false)
      expect(game.is_available_cell(2, 6)).to eq(false)
      expect(game.is_available_cell(2, 7)).to eq(false)

      expect(game.is_available_cell(3, 0)).to eq(false)
      expect(game.is_available_cell(3, 1)).to eq(false)
      expect(game.is_available_cell(3, 2)).to eq(true)
      #expect(game.is_available_cell(3, 3)).to eq(false)
      #expect(game.is_available_cell(3, 4)).to eq(true)
      expect(game.is_available_cell(3, 5)).to eq(false)
      expect(game.is_available_cell(3, 6)).to eq(false)
      expect(game.is_available_cell(3, 7)).to eq(false)

      expect(game.is_available_cell(4, 0)).to eq(false)
      expect(game.is_available_cell(4, 1)).to eq(false)
      expect(game.is_available_cell(4, 2)).to eq(false)
      #expect(game.is_available_cell(4, 3)).to eq(false)
      #expect(game.is_available_cell(4, 4)).to eq(true)
      expect(game.is_available_cell(4, 5)).to eq(true)
      expect(game.is_available_cell(4, 6)).to eq(false)
      expect(game.is_available_cell(4, 7)).to eq(false)

      expect(game.is_available_cell(5, 0)).to eq(false)
      expect(game.is_available_cell(5, 1)).to eq(false)
      expect(game.is_available_cell(5, 2)).to eq(false)
      expect(game.is_available_cell(5, 3)).to eq(false)
      expect(game.is_available_cell(5, 4)).to eq(true)
      expect(game.is_available_cell(5, 5)).to eq(false)
      expect(game.is_available_cell(5, 6)).to eq(false)
      expect(game.is_available_cell(5, 7)).to eq(false)

      expect(game.is_available_cell(6, 0)).to eq(false)
      expect(game.is_available_cell(6, 1)).to eq(false)
      expect(game.is_available_cell(6, 2)).to eq(false)
      expect(game.is_available_cell(6, 3)).to eq(false)
      expect(game.is_available_cell(6, 4)).to eq(false)
      expect(game.is_available_cell(6, 5)).to eq(false)
      expect(game.is_available_cell(6, 6)).to eq(false)
      expect(game.is_available_cell(6, 7)).to eq(false)

      expect(game.is_available_cell(7, 0)).to eq(false)
      expect(game.is_available_cell(7, 1)).to eq(false)
      expect(game.is_available_cell(7, 2)).to eq(false)
      expect(game.is_available_cell(7, 3)).to eq(false)
      expect(game.is_available_cell(7, 4)).to eq(false)
      expect(game.is_available_cell(7, 5)).to eq(false)
      expect(game.is_available_cell(7, 6)).to eq(false)
      expect(game.is_available_cell(7, 7)).to eq(false)
    end

  end

  #  0 1 2 3 4 5 6 7
  #0
  #1
  #2       b
  #3       w b
  #4       b w
  #5
  #6
  #7
  describe "handle_turn" do
    it "Validate handle turn" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 1
      game = game.handle_turn(2, 3)

      expect(game.turn).to eq(2)
      expect(game.board[2][3]).to eq(:b)
      expect(game.board[3][3]).to eq(:b)
      expect(game.history.length).to eq(1)
      expect(game.history[0]).to eq("b_2_3")
    end
  end

  describe "reverse" do
    #  0 1 2 3 4 5 6 7
    #0 b b b b b b b b
    #1 b w w w w w w w
    #2 w w w w w w w b
    #3 w w w w w w w w
    #4 w w w w w w w w
    #5 b w w w*b w w b
    #6 w w w w w w w w
    #7 w w b w b w b w
    it "Validate reverse(Up)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 1
      # 初期化
      for i in 0..7 do
        for j in 0..7 do
          game.board[i][j] = :w
        end
      end
      for j in 0..7 do
        game.board[0][j] = :b
      end
      game.board[1][0] = :b
      game.board[2][7] = :b
      game.board[5][0] = :b
      game.board[5][4] = :b
      game.board[5][7] = :b
      game.board[7][2] = :b
      game.board[7][4] = :b
      game.board[7][6] = :b

      # ひっくり返す
      game.reverse( 5, 4, :b)

      # 上
      expect(game.board[0][4]).to eq(:b)
      expect(game.board[1][4]).to eq(:b)
      expect(game.board[2][4]).to eq(:b)
      expect(game.board[3][4]).to eq(:b)
      expect(game.board[4][4]).to eq(:b)
      # 置いた場所
      expect(game.board[5][4]).to eq(:b)
      # # 右上
      expect(game.board[4][5]).to eq(:b)
      expect(game.board[3][6]).to eq(:b)
      expect(game.board[2][7]).to eq(:b)
      # 右
      expect(game.board[5][5]).to eq(:b)
      expect(game.board[5][6]).to eq(:b)
      expect(game.board[5][7]).to eq(:b)
      # 右下
      expect(game.board[6][5]).to eq(:b)
      expect(game.board[7][6]).to eq(:b)
      # 下
      expect(game.board[6][4]).to eq(:b)
      expect(game.board[7][4]).to eq(:b)
      # 左下
      expect(game.board[6][3]).to eq(:b)
      expect(game.board[7][2]).to eq(:b)
      # 左
      expect(game.board[5][0]).to eq(:b)
      expect(game.board[5][1]).to eq(:b)
      expect(game.board[5][2]).to eq(:b)
      expect(game.board[5][3]).to eq(:b)
      # 左上
      expect(game.board[4][3]).to eq(:b)
      expect(game.board[3][2]).to eq(:b)
      expect(game.board[2][1]).to eq(:b)
      expect(game.board[1][0]).to eq(:b)
    end

  end


  describe "reverse_dir" do

    #  0 1 2 3 4 5 6 7
    #0
    #1
    #2
    #3       w b
    #4       b w
    #5        *b
    #6
    #7
    it "Validate reverse(Up)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 1
      game.board[5][4] = :b
      game.reverse_dir( 5, 4, :b, Game::Dir::UP)

      expect(game.board[0][4]).to eq(nil)
      expect(game.board[1][4]).to eq(nil)
      expect(game.board[2][4]).to eq(nil)
      expect(game.board[3][4]).to eq(:b)
      expect(game.board[4][4]).to eq(:b)
      expect(game.board[5][4]).to eq(:b)
      expect(game.board[6][4]).to eq(nil)
      expect(game.board[7][4]).to eq(nil)
    end

    #  0 1 2 3 4 5 6 7
    #0         b
    #1         w
    #2         w
    #3       w w
    #4       b w
    #5        *b
    #6
    #7
    it "Validate reverse(no Up)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 1
      game.board[0][4] = :b
      game.board[1][4] = :w
      game.board[2][4] = :w
      game.board[3][4] = :w
      game.board[4][4] = :w
      game.board[5][4] = :b
      game.reverse_dir( 5, 4, :b, Game::Dir::UP)

      expect(game.board[0][4]).to eq(:b)
      expect(game.board[1][4]).to eq(:b)
      expect(game.board[2][4]).to eq(:b)
      expect(game.board[3][4]).to eq(:b)
      expect(game.board[4][4]).to eq(:b)
      expect(game.board[5][4]).to eq(:b)
      expect(game.board[6][4]).to eq(nil)
      expect(game.board[7][4]).to eq(nil)
    end

  end

  describe "is_finish" do
    it "Validate finish the game(no finish)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 1
      expect(game.is_finish).to eq(false)
    end
    it "Validate finish the game(1 time pass)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 1
      game.history.push("pass")
      expect(game.is_finish).to eq(false)
    end
    it "Validate finish the game(2 continuous pass)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 2
      game.history.push("pass")
      game.history.push("pass")
      expect(game.is_finish).to eq(true)
    end
    it "Validate finish the game(all cell was filled)" do
      game = Game.new
      game.player_even = "even@address.com"
      game.player_odd = "odd@address.com"
      game.turn = 2
      for row in 0..7 do
        for col in 0..7 do
          game.board[row][col] = :w
        end
      end
      expect(game.is_finish).to eq(true)
    end
  end

  describe "get_count" do
    it "Validate number of discs" do
      game = Game.new
      game.board[0][0] = :w
      game.board[0][1] = :b
      expect(game.get_count[:b]).to eq(3)
      expect(game.get_count[:w]).to eq(3)
    end
  end

end
