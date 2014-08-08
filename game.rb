require 'mongo'
require 'base64'
require 'uri'

class Game

  attr_accessor :_id,:player_even, :player_odd, :turn, :board, :history, :pass_url

  #  0 1 2 3 4 5 6 7
  #0
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
    obj._id = data["_id"]
    obj.player_even = data["player_even"]
    obj.player_odd = data["player_odd"]
    obj.turn = data["turn"]
    obj.board = data["board"]
    obj.history = data["history"]
    obj
  end

  def to_prepared(app_host)
    prep = Game.new
    prep._id = @_id
    prep.player_even = @player_even
    prep.player_odd = @player_odd
    prep.turn = @turn
    prep.pass_url = Game.generate_cell_url(app_host, @_id, @turn, -1, -1)

    # Embed Link tag
    for row in 0..7 do
      for col in 0..7 do
        # only nil cell
        if @board[row][col] == nil then
          if is_available_cell(row, col) then
            url = Game.generate_cell_url(app_host, @_id, @turn, row, col)
            prep.board[row][col] = "<a href='#{url}'><img style='width: 100%;' src='#{app_host}/n.png'></a>"
          else
            prep.board[row][col] = "<img style='width: 100%;' src='#{app_host}/n.png'>"
          end
        end
      end
    end

    # Embed IMG tag
    for row in 0..7 do
      for col in 0..7 do
        case @board[row][col]
        when :b then
          prep.board[row][col] = "<img style='width: 100%;' src='#{app_host}/b.png'>"
        when :w then
          prep.board[row][col] = "<img style='width: 100%;' src='#{app_host}/w.png'>"
        end
      end
    end
    prep
  end

  def self.generate_cell_url(host, obj_id, turn, row, col)
    "#{host}/event?obj_id=#{obj_id}&turn=#{turn}&row=#{row}&col=#{col}"
  end

  def self.parse_cell_url(url)
    data = {}
    uri = URI.parse(url)
    uri.query.split('&').each {|q|
      kv = q.split('=')
      data[kv[0]] = kv[1]
    }
    data['turn'] = data['turn'].to_i
    data['row'] = data['row'].to_i
    data['col'] = data['col'].to_i
    data
  end

  def is_available_cell(row, col)
    return true if is_available_dir(row, col, Dir::UP)
    return true if is_available_dir(row, col, Dir::UP_RIGHT)
    return true if is_available_dir(row, col, Dir::RIGHT)
    return true if is_available_dir(row, col, Dir::DOWN_RIGHT)
    return true if is_available_dir(row, col, Dir::DOWN)
    return true if is_available_dir(row, col, Dir::DOWN_LEFT)
    return true if is_available_dir(row, col, Dir::LEFT)
    return true if is_available_dir(row, col, Dir::UP_LEFT)
    false
  end

  def is_available_dir(st_row, st_col, dir)
    # even is white. odd is black.
    (turn % 2 == 0) ? pebble = :w : pebble = :b
    has_possible = false
    i = 0
    begin
      # move target cell
      i += 1
      tg_row = st_row + dir[:delta_row] * i
      tg_col = st_col + dir[:delta_col] * i

      break if tg_row < 0
      break if tg_col < 0
      break if tg_row > 7
      break if tg_col > 7

      # unavailable if neighbor cell is nil
      return false if @board[tg_row][tg_col] == nil

      if has_possible == true then
        # available if it can be between
        return true if @board[tg_row][tg_col] == pebble
      else
        # unavailable if neighbor is same color
        return false if @board[tg_row][tg_col] == pebble
        # possible if neighbor is not same color. go next loop.
        has_possible = true
        next
      end
      # until end of board
    end while (tg_row <= 7 && tg_row >= 0 && tg_col <= 7 && tg_col >= 0)
    # finish the check
    false
  end

  def handle_turn(row, col)
    # even is white. odd is black.
    (turn % 2 == 0) ? pebble = :w : pebble = :b
    # process the game if valid cell
    if row >= 0 && row <= 7 && col >= 0 && col <= 7 then
      @board[row][col] = pebble
      reverse(row, col, pebble)
      @history.push("#{pebble.to_s}_#{row}_#{col}")
    else
      @history.push("pass")
    end
    @turn += 1
    self
  end

  def is_finish
    # finish if 2 passes continue
    return true if @history[-1] == "pass" && @history[-2] == "pass"
    # no place
    for row in 0..7 do
      for col in 0..7 do
        return false if @board[row][col] == nil
      end
    end
    true
  end

  def reverse(row, col, pebble)
    reverse_dir(row, col, pebble, Dir::UP)         if is_available_dir(row, col, Dir::UP)
    reverse_dir(row, col, pebble, Dir::UP_RIGHT)   if is_available_dir(row, col, Dir::UP_RIGHT)
    reverse_dir(row, col, pebble, Dir::RIGHT)      if is_available_dir(row, col, Dir::RIGHT)
    reverse_dir(row, col, pebble, Dir::DOWN_RIGHT) if is_available_dir(row, col, Dir::DOWN_RIGHT)
    reverse_dir(row, col, pebble, Dir::DOWN)       if is_available_dir(row, col, Dir::DOWN)
    reverse_dir(row, col, pebble, Dir::DOWN_LEFT)  if is_available_dir(row, col, Dir::DOWN_LEFT)
    reverse_dir(row, col, pebble, Dir::LEFT)       if is_available_dir(row, col, Dir::LEFT)
    reverse_dir(row, col, pebble, Dir::UP_LEFT)    if is_available_dir(row, col, Dir::UP_LEFT)
  end

  def reverse_dir(st_row, st_col, pebble, dir)
    i = 0
    begin
      # move target cell
      i += 1
      tg_row = st_row + dir[:delta_row] * i
      tg_col = st_col + dir[:delta_col] * i

      break if tg_row < 0
      break if tg_col < 0
      break if tg_row > 7
      break if tg_col > 7
      break if @board[tg_row][tg_col] == pebble

      @board[tg_row][tg_col] = pebble

      # until end of board
    end while (tg_row <= 7 && tg_row >= 0 && tg_col <= 7 && tg_col >= 0)
  end

  module Dir
    UP          = {:delta_row => -1, :delta_col => 0}
    UP_RIGHT    = {:delta_row => -1, :delta_col => 1}
    RIGHT       = {:delta_row =>  0, :delta_col => 1}
    DOWN_RIGHT  = {:delta_row =>  1, :delta_col => 1}
    DOWN        = {:delta_row =>  1, :delta_col => 0}
    DOWN_LEFT   = {:delta_row =>  1, :delta_col =>-1}
    LEFT        = {:delta_row =>  0, :delta_col =>-1}
    UP_LEFT     = {:delta_row => -1, :delta_col =>-1}
  end
end
