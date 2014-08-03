require 'mongo'

class Game

  attr_accessor :_id,:player_even, :player_odd, :turn, :board, :history

  #0 0 1 2 3 4 5 6 7
  #1
  #2
  #3       w b
  #4       b w
  #5
  #6
  #7
  def initialize
    @_id = BSON::ObjectId.new
    @player_even = ""
    @player_odd = ""
    @turn = 1
    @board = Array.new(8).map{Array.new(8,nil)}
    @board[3][3] = :w
    @board[3][4] = :b
    @board[4][3] = :b
    @board[4][4] = :w
    @history = []
  end

  def to_array
    data = {}
    data["_id"] = @_id
    data["player_even"] = @player_even
    data["player_odd"] = @player_odd
    data["turn"] = @turn
    data["board"] = @board
    data["history"] = @history
    data
  end

  def self.create_new(data)
    obj = Game.new
    obj.player_even = data["player_even"]
    obj.player_odd = data["player_odd"]
    obj.turn = data["turn"]
    obj.board = data["board"]
    obj.history = data["history"]
    obj
  end

end
