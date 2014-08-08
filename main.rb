require 'sinatra'
require 'sinatra/reloader'
require 'json'
require './db_access'
require './addresses'
require './mailer'
require './game'

post '/game' do

  #puts params.inspect
  # メールアドレスを抽出する
  from = Addresses.get_address(params[:from])
  to = Addresses.get_address(params[:subject])

  # nilの場合アドレス抽出に失敗した
  mailer = Mailer.new
  if from != nil && to == nil then
    mailer.send_message(from, "対戦相手のメールアドレスの抽出に失敗しました。件名に対戦相手のメールアドレスをセットしてメールを送信してください。")
    return 'Fail to parse to address'
  end
  if from == nil && to == nil then
    puts "アドレスの抽出に失敗しました。リクエスト内容を確認して下さい。"
    puts "from: #{params[:from]}"
    puts "subject: #{params[:subject]}"
    return 'Fail to parse to and from address'
  end

  # DBでセッションレコードの存在を確認する
  dba = DbAccess.new
  game = dba.find(from, to)
  # なければ新規ゲーム生成
  if game == nil then
    game = Game.new
    game.player_odd = to      # 奇数：先手(黒)
    game.player_even = from   # 偶数：後手(白)
    id = dba.insert(game)
    game = dba.findById(id)
    puts "new game: #{game._id}"
  end

  # 各プレイヤーに適切なメール送信
  mailer.send(game)

  'Hello'
end

post '/event' do
  request.body.rewind
  data = JSON.parse(request.body.read)

  data.each{|event|
    begin
      # clickイベントのみ処理
      break if event['event'] != "click"
      # 送信元アドレス
      email = event['email']
      # urlをパース
      event_data = Game.parse_cell_url(event['url'])
      # イベントを検査
      game = validate_event(event_data)
      if game == nil then
        puts "該当ゲームが見つからないので無視したいところ"
        break
      end
      # イベントの処理
      game = game.handle_turn(event_data['row'], event_data['col'])
      # 保存
      dba = DbAccess.new
      dba.update(game)
      # 通知メール
      mailer = Mailer.new
      mailer.send(game)

    rescue => e
      puts e.backtrace
      puts e.inspect
      mailer = Mailer.new
      mailer.send_message(email, "異常なイベント発生") if email != nil
    end
  }

  'Success'
end

def validate_event(event_data)
  # Clickイベントの内容の正当性評価
  dba = DbAccess.new
  puts "obj_id: #{event_data["obj_id"]}"
  dba.findById(BSON::ObjectId.from_string(event_data["obj_id"]))
end

get '/event' do
  # セキュリティ上の理由でgetイベントは処理しない。
  # ユーザ契機のイベントは全てpostで処理する。
  '受け付けました。'
end
