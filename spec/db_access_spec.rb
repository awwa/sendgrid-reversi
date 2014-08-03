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

  describe "findById" do
    it "存在しないIDによる検査" do
      dba = DbAccess.new
      dba.dropAll
      actual = dba.findById("000")
      actual.should == nil
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
