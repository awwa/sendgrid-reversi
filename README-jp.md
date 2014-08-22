sendgrid-reversi
================
SendGrid-Reversiはオープンソースのデモプロジェクトです。  

# どうやって動くの？

このアプリケーションはSinatra上で動作するRubyアプリケーションです。  
このアプリケーションはいくつかのSendGrid APIを使用します。
* Web API(Mail, Filter Settings, Parse Webhook Settings)
* SMTP API(To, Substitutions, Filters)
* Parse Webhook
* Event Webhook (Click)
* Template Engine API

また、このアプリケーションはゲームデータとテンプレートIDをMongoDBに保存します。

# 必要条件
* [Ruby](https://www.ruby-lang.org) 2.0.0 or higher
* [Bundler](http://bundler.io/) ([Sinatra](http://www.sinatrarb.com/), [sendgrid_ruby](https://github.com/SendGridJP/sendgrid-ruby),[sendgrid_template_engine](https://github.com/awwa/sendgrid_template_engine_ruby)... 詳細は[Gemfile](https://github.com/awwa/sendgrid-reversi/blob/master/Gemfile)参照)
* [MongoDB](http://www.mongodb.org/)
* [ngrok](https://ngrok.com/) (ローカル環境で起動する場合)

# インストールとセットアップ

##### 1. ngrokの起動  
[ngrok](https://ngrok.com/)はアプリケーションをローカル環境で起動する場合、簡単にサービスを公開することができます。  
'4567'はトンネリングするポート番号です。  
ngrokを起動してForwarding URLを確認します。（あとで設定ファイルに記載します）  
``` bash
$ ngrok 4567  
ngrok                                                                                                                                                                                                                         (Ctrl+C to quit)
Tunnel Status                 online
Version                       1.6/1.6
Forwarding                    http://awwa500.ngrok.com -> 127.0.0.1:4567
Forwarding                    https://awwa500.ngrok.com -> 127.0.0.1:4567
Web Interface                 127.0.0.1:4040
# Conn                        0
Avg Conn Time                 0.00ms
```

##### 2. GitHubからソースコードを取得します
``` bash
$ git clone https://github.com/awwa/sendgrid-reversi.git
$ cd sendgrid-reversi
```

##### 3. bundle installを実行します
``` bash
$ bundle install
```

##### 4. .envファイルをコピーします
``` bash
$ cp .env.example .env
```

##### 5. .envファイルを編集します
``` bash
vi .env
SENDGRID_USERNAME=your_username
SENDGRID_PASSWORD=your_password
APP_URL=http://app.host.example.com
PARSE_HOST=your.receive.domain
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_DB=reversi
MONGO_USERNAME=
MONGO_PASSWORD=
```

|パラメータ           |詳細                          |
|:--------------------|:------------------------------------|
|**SENDGRID_USERNAME**|SendGridのユーザ名              |
|**SENDGRID_PASSWORD**|SendGridのパスワード              |
|**APP_URL**          |アプリケーションのURL。ngrokを使う場合、'Forwarding' URLです。 |
|**PARSE_HOST**       |メールを受信するドメイン名        |
|**MONGO_HOST**       |MongoDBを実行するホスト名   |
|**MONGO_PORT**       |MongoDBが使用するポート番号|
|**MONGO_DB**         |DB名。通常、'reversi'のままでOK。|
|**MONGO_USERNAME**   |MongoDBのユーザ名。認証が不要な場合、空にしてください。|
|**MONGO_PASSWORD**   |MongoDBのパスワード|

# アプリケーションの起動
##### 1. mongodの起動  
``` bash
$ mongod
```
##### 2. アプリケーションの起動  
このアプリケーションは初回起動時にSendGridをセットアップします。また、サービスを起動します。  
``` bash
$ RACK_ENV=production rackup -p 4567
```

# 遊び方

##### 1. ゲームの開始  
プレイヤー1はPARSE_HOSTドメインの任意のアドレスにメールを送信します。  
この際、件名にはプレイヤー2のメールアドレスを含めてください。  
``` text
To: game@your.receive.domain
Subject: player2@address.test
```

##### 2. メールを受信してそれをクリックします
Player2は以下のようなメールを受信します。  
石を置きたいセルをクリックしてください。  
<img src="https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/dev/board_html.png" width="450px" />  
その後、各プレイヤーは同様なメールを受信して石を置きたいセルをクリックしてゲームを進めます。  

##### 3. パスする  
ボードの下にある'Pass your turn'をクリックすることでパスすることができます。  

##### 4. ゲームの終了  
以下の場合、ゲームは終了します。
  * 全てのセルに石が置かれた
  * 各プレイヤーが連続してパスした

##### 5. text/plainパート  
メールクライアントがHTMLメールをサポートしていない場合、以下のようなtext/plainバージョンが利用できる場合があります。  
<img src="https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/dev/board_plain.png" width="450px" />  

# 制限事項
「ブラウザベースのアプリケーション作ればいいじゃん」などと言うのは厳禁です。
これはあくまでもデモアプリケーションです。;-)
