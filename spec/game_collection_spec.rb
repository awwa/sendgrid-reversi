# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "GameCollection" do
  describe "initialize" do
    it "Validate constructor" do
      dba = GameCollection.new
    end
  end

  describe "drop_all" do
    it "Validate drop all collections" do
      dba = GameCollection.new
      dba.drop_all
    end
  end

  describe "insert" do
    it "Validate insert" do
      game = Game.new
      dba = GameCollection.new
      dba.drop_all
      id = dba.insert(game)
      expect(id.class.name).to eq("BSON::ObjectId")
      gameActual = dba.findById(id)
      expect(gameActual.player_odd).to eq("")
      expect(gameActual.player_even).to eq("")
    end
  end

  describe "update" do
    it "Validate update if not exist case" do
      game = Game.new
      dba = GameCollection.new
      dba.drop_all
      ret = dba.update(game)
      expect(ret['n']).to eq(0)
    end

    it "Validate update if exist case" do
      game = Game.new
      dba = GameCollection.new
      dba.drop_all
      ret = dba.insert(game)
      game.player_odd = "odd@address.com"
      game.player_even = "even@address.com"
      game.turn = 2
      game.board[0][0] = :w
      game.history.push("w_0_0")
      dba.update(game)

      actual = dba.find("odd@address.com", "even@address.com")
      expect(actual._id.class).to eq(BSON::ObjectId)
      expect(actual.player_odd).to eq("odd@address.com")
      expect(actual.player_even).to eq("even@address.com")
      expect(actual.turn).to eq(2)
      expect(actual.board[0][0]).to eq(:w)
      expect(actual.history[0]).to eq("w_0_0")
    end
  end

  describe "findById" do
    it "Validate find by id if not exist id" do
      dba = GameCollection.new
      dba.drop_all
      actual = dba.findById(BSON::ObjectId.from_string("53e317befe1c1d2b39000001"))
      expect(actual).to eq(nil)
    end
    it "Validate find by id if exist id" do
      dba = GameCollection.new
      dba.drop_all
      game = Game.new
      expect_id = dba.insert(game)
      actual = dba.findById(expect_id)
      expect(actual._id).to eq(expect_id)
    end
  end

  describe "find" do
    it "Validate find by player normal order" do
      dba = GameCollection.new
      dba.drop_all

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
      expect(actual1.class).to eq(Game)
      expect(actual1.player_even).to eq("even1@address.com")
      expect(actual1.player_odd).to eq("odd1@address.com")
    end

    it "Validate find by player opposite order" do
      dba = GameCollection.new
      dba.drop_all

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
      expect(actual1.class).to eq(Game)
      expect(actual1.player_even).to eq("even1@address.com")
      expect(actual1.player_odd).to eq("odd1@address.com")
    end

    it "Validate find by player if not exist" do
      dba = GameCollection.new
      dba.drop_all

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
      expect(actual1).to eq(nil)
    end
  end

  describe "remove" do
    it "Validate remove if exist" do
      dba = GameCollection.new
      dba.drop_all

      game = Game.new
      expect_id = dba.insert(game)
      res = dba.remove(expect_id)
      expect(res["ok"]).to eq(1)
      expect(res["n"]).to eq(1)
    end

    it "Validate remove if not exist" do
      dba = GameCollection.new
      dba.drop_all

      game = Game.new
      expect_id = dba.insert(game)
      res = dba.remove(BSON::ObjectId.from_string("000000000000000000000000"))
      expect(res["ok"]).to eq(1)
      expect(res["n"]).to eq(0)
    end
  end
end
