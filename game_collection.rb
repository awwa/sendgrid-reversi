require 'mongo'
require './db_access'

class GameCollection < DbAccess

  def initialize
    super("games")
    @coll.create_index({:player_even => Mongo::ASCENDING, :player_odd => Mongo::ASCENDING}, {:unique => :true})
  end

  def findById(id)
    row = @coll.find_one({:_id => id})
    game = Game.create_new(row) if row != nil
    game
  end

  def find(player_even, player_odd)
    row = @coll.find_one(:player_even => player_even, :player_odd => player_odd)
    game = Game.create_new(row) if row != nil
    return game if game != nil

    row = @coll.find_one(:player_even => player_odd, :player_odd => player_even)
    game = Game.create_new(row) if row != nil
    return game if game != nil
    nil
  end

end
