require 'sinatra'
require 'sinatra/reloader'
require 'json'
require './db_access'

post '/game' do

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
    game.player_odd = to
    game.player_even = from
    dba.insert(game)
  end

  # turn==1の場合、player_evenには受け付け完了メール送信
  if game.turn == 1 then
    mailer.send_message(game.player_even, "対戦リクエストを受け付けました。しばらくお待ちください。")
    #mailer.send()
  end

  # turn>1の場合、セッションレコードを元に各プレイヤーに応答メール送信
  if game.turn > 1 then

  end

  'Hello'
end

post '/event' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  puts "body: #{data}"

  # TODO Clickイベントのみ抽出
  # TODO Clickイベントの内容の正当性評価

  # switch
  # TODO 正当
    # イベントの処理
  # TODO 不正
    # 無視もしくは通知メール

  1
end
