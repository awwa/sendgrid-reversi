require 'mongo'
require 'base64'
require 'uri'

class Game

  IMG_N = "<img style='width: 100%;'  src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/n.png'>"
  IMG_B = "<img style='width: 100%;'  src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/b.png'>"
  IMG_W = "<img style='width: 100%;'  src='https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/public/w.png'>"

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
    obj._id = data["_id"]
    obj.player_even = data["player_even"]
    obj.player_odd = data["player_odd"]
    obj.turn = data["turn"]
    obj.board = data["board"]
    obj.history = data["history"]
    obj
  end

#
#
#    *
#    bw
#    wb
#
#
#


  def to_prepared
    prep = Game.new
    prep._id = @_id
    prep.player_even = @player_even
    prep.player_odd = @player_odd
    prep.turn = @turn

    # Embed Link tag
    for row in 0..7 do
      for col in 0..7 do
        # 空セルのみチェック対象
        if @board[row][col] == nil then
          if check_available(row, col) then
            url = Game.generate_cell_url(ENV["APP_HOST"], @_id, @turn, row, col)
            prep.board[row][col] = "<a href='#{url}'>□</a>"
          else
            prep.board[row][col] = ""
          end
        end
      end
    end

    # Embed IMG tag
    for row in 0..7 do
      for col in 0..7 do
        case @board[row][col]
        when :b then
          prep.board[row][col] = IMG_B
        when :w then
          prep.board[row][col] = IMG_W
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

  def check_available(row, col)
    # ある場所を起点として8方向にチェックしていき、挟めるなら置ける場所と判断
    ret = check_loop(row, col, -1, 0)  # 上
    return ret if ret == true
    ret = check_loop(row, col, -1, 1)  # 上右
    return ret if ret == true
    ret = check_loop(row, col,  0, 1)  # 　右
    return ret if ret == true
    ret = check_loop(row, col,  1, 1)  # 下右
    return ret if ret == true
    ret = check_loop(row, col,  1, 0)  # 下
    return ret if ret == true
    ret = check_loop(row, col,  1,-1)  # 下左
    return ret if ret == true
    ret = check_loop(row, col,  0,-1)  # 　左
     return ret if ret == true
    ret = check_loop(row, col, -1,-1)  # 上左
    return ret if ret == true
    # いずれにも該当しない場合false
    false
  end

  def check_loop(st_row, st_col, delta_row, delta_col)
    # 偶数ターン：白の番、奇数ターン：黒の番
    is_even = (turn % 2 == 0)
    # 置ける可能性
    ret = false
    i = 0
    begin
      # ターゲットセル移動
      i += 1
      tg_row = st_row + delta_row * i
      tg_col = st_col + delta_col * i

      break if tg_row < 0
      break if tg_col < 0
      break if tg_row > 7
      break if tg_col > 7

      # 隣が空セルの場合無条件で対象外
      return false if @board[tg_row][tg_col] == nil

      # 偶数ターン=白の番
      if is_even then
        if ret == true then
          # 可能性あり状態で隣が白の場合挟める
          return true if @board[tg_row][tg_col] == :w
        else
          # 隣が白の場合対象外
          return false if @board[tg_row][tg_col] == :w
          # 隣が黒の場合可能性あり。次のループへ
          ret = true
          next
        end
      end

      # 奇数ターン=黒の番
      if !is_even then
        if ret == true then
          # 可能性あり状態で隣が黒の場合挟める
          return true if @board[tg_row][tg_col] == :b
        else
          # 隣が黒の場合対象外
          return false if @board[tg_row][tg_col] == :b
          # 隣が白の場合可能性あり。次のループへ
          ret = true
          next
        end
      end
      # 盤をはみ出すまでチェック
    end while (tg_row <= 7 && tg_row >= 0 && tg_col <= 7 && tg_col >= 0)
    # 盤をはみ出したらおしまい
    false
  end

  def handle_turn(row, col)
    is_even = (turn % 2 == 0)
    if is_even then
      pebble = :w
    else
      pebble = :b
    end
    # クリックした場所に石を置く
    @board[row][col] = pebble
    # ひっくり返す
    reverse(row, col, pebble)
    # 歴史を刻む
    @history.push("#{pebble.to_s}_#{row}_#{col}")
    # ターンを進める
    @turn += 1
    self
  end

  def reverse(row, col, pebble)
    puts "reverse0"
    reverse_loop(row, col, pebble, -1, 0) if check_loop(row, col, -1, 0)  # 上
    puts "reverse1"
    reverse_loop(row, col, pebble, -1, 1) if check_loop(row, col, -1, 1)  # 上右
    puts "reverse2"
    reverse_loop(row, col, pebble,  0, 1) if check_loop(row, col,  0, 1)  # 　右
    puts "reverse3"
    reverse_loop(row, col, pebble,  1, 1) if check_loop(row, col,  1, 1)  # 下右
    puts "reverse4"
    reverse_loop(row, col, pebble,  1, 0) if check_loop(row, col,  1, 0)  # 下
    puts "reverse5"
    reverse_loop(row, col, pebble,  1,-1) if check_loop(row, col,  1,-1)  # 下左
    puts "reverse6"
    reverse_loop(row, col, pebble,  0,-1) if check_loop(row, col,  0,-1)  # 　左
    puts "reverse7"
    reverse_loop(row, col, pebble, -1,-1) if check_loop(row, col, -1,-1)  # 上左
    puts "reverse8"
  end

  def reverse_loop(st_row, st_col, pebble, delta_row, delta_col)
    i = 0
    begin
      # ターゲットセル移動
      i += 1
      tg_row = st_row + delta_row * i
      tg_col = st_col + delta_col * i

      break if tg_row < 0
      break if tg_col < 0
      break if tg_row > 7
      break if tg_col > 7
      break if @board[tg_row][tg_col] == pebble

      @board[tg_row][tg_col] = pebble

      # 盤をはみ出すまでチェック
    end while (tg_row <= 7 && tg_row >= 0 && tg_col <= 7 && tg_col >= 0)
  end

end
