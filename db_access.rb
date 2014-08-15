require 'mongo'

class DbAccess

  attr_accessor :db, :coll

  def initialize(coll_name)
    @connection = Mongo::Connection.new('localhost') # TODO 環境変数にする
    @db = @connection.db('reversi')
    @coll = @db.collection(coll_name)
  end

  def insert(doc)
    @coll.insert(doc.to_array)
  end

  def update(doc)
    @coll.update({:_id => doc._id}, doc.to_array)
  end

  def remove(id)
    @coll.remove({:_id => id})
  end

  def dropAll
    @coll.drop
  end


end
