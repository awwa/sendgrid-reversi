require 'mongo'

class DbAccess

  def initialize
    @connection = Mongo::Connection.new('localhost') # TODO 環境変数にする
    db = @connection.db('reversi')
    @coll = db.collection('games')
    @coll.create_index({:player_even => Mongo::ASCENDING, :player_odd => Mongo::ASCENDING}, {:unique => :true})
  end

  def insert(doc)
    @coll.insert(doc.to_array)
  end

  def findById(id)
    row = @coll.find_one({:_id => id})
    game = Game.create_new(row) if row != nil
    game
  end

  def find(player_even, player_odd)
    # find game row
    row = @coll.find_one(:player_even => player_even, :player_odd => player_odd)
    game = Game.create_new(row) if row != nil
    return game if game != nil

    row = @coll.find_one(:player_even => player_odd, :player_odd => player_even)
    game = Game.create_new(row) if row != nil
    return game if game != nil
    # if not exists return nil.
    nil
  end

  def dropAll
    @coll.drop
  end


end
