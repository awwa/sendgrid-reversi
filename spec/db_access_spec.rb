# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "DbAccess" do
  describe "initialize" do
    it "初期値検査" do
      dba = DbAccess.new
    end
  end

  describe "dropAll" do
    it "全削除検査" do
      dba = DbAccess.new
      dba.dropAll
    end
  end

  describe "insert" do
    it "挿入検査" do
      game = Game.new
      dba = DbAccess.new
      dba.dropAll
      id = dba.insert(game)
      id.class.name.should == "BSON::ObjectId"
      gameActual = dba.findById(id)
      gameActual.player_odd.should == ""
      gameActual.player_even.should == ""
    end
  end

  describe "update" do
    it "存在しない場合の更新検査" do
      game = Game.new
      dba = DbAccess.new
      dba.dropAll
      ret = dba.update(game)
      ret['n'].should == 0
    end

    it "存在する場合の更新検査" do
      game = Game.new
      dba = DbAccess.new
      dba.dropAll
      ret = dba.insert(game)
      game.player_odd = "odd@address.com"
      game.player_even = "even@address.com"
      game.turn = 2
      game.board[0][0] = :w
      game.history.push("w_0_0")
      dba.update(game)

      actual = dba.find("odd@address.com", "even@address.com")
      actual._id.class.should == BSON::ObjectId
      actual.player_odd.should == "odd@address.com"
      actual.player_even.should == "even@address.com"
      actual.turn.should == 2
      actual.board[0][0].should == :w
      actual.history[0].should == "w_0_0"
    end
  end

  describe "findById" do
    it "存在しないIDによる検査" do
      dba = DbAccess.new
      dba.dropAll
      actual = dba.findById(BSON::ObjectId.from_string("53e317befe1c1d2b39000001"))
      actual.should == nil
    end
    it "存在するIDによる検査" do
      dba = DbAccess.new
      dba.dropAll
      game = Game.new
      expect_id = dba.insert(game)
      actual = dba.findById(expect_id)
      actual._id.should == expect_id
    end
  end

  describe "find" do
    it "正常なplayerによる検索" do
      dba = DbAccess.new
      dba.dropAll

      game1 = Game.new
      game1.player_even = "even1@address.com"
      game1.player_odd = "odd1@address.com"
      game1.turn = 1
      id1 = dba.insert(game1)

      game2 = Game.new
      game2.player_even = "even2@address.com"
      game2.player_odd = "odd2@address.com"
      game2.turn = 1
      id2 = dba.insert(game2)

      actual1 = dba.find("even1@address.com", "odd1@address.com")
      actual1.class.should == Game
      actual1.player_even = "even1@address.com"
      actual1.player_odd = "odd1@address.com"
    end

    it "逆順playerによる検索" do
      dba = DbAccess.new
      dba.dropAll

      game1 = Game.new
      game1.player_even = "even1@address.com"
      game1.player_odd = "odd1@address.com"
      game1.turn = 1
      id1 = dba.insert(game1)

      game2 = Game.new
      game2.player_even = "even2@address.com"
      game2.player_odd = "odd2@address.com"
      game2.turn = 1
      id2 = dba.insert(game2)

      actual1 = dba.find("odd1@address.com", "even1@address.com")
      actual1.class.should == Game
      actual1.player_even = "even1@address.com"
      actual1.player_odd = "odd1@address.com"
    end

    it "存在しないplayerによる検索" do
      dba = DbAccess.new
      dba.dropAll

      game1 = Game.new
      game1.player_even = "even1@address.com"
      game1.player_odd = "odd1@address.com"
      game1.turn = 1
      id1 = dba.insert(game1)

      game2 = Game.new
      game2.player_even = "even2@address.com"
      game2.player_odd = "odd2@address.com"
      game2.turn = 1
      id2 = dba.insert(game2)

      actual1 = dba.find("odd1@address.com", "even2@address.com")
      actual1.should == nil
    end

  end
end
