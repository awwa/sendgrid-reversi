sendgrid-reversi
================
The SendGrid-Reversi is an open source demo project.  

# How it works

This application is Ruby application to work on Sinatra.  
This uses some of SendGrid APIs.
* Web API(Mail, Filter Settings, Parse Webhook Settings)
* SMTP API(To, Substitutions, Filters)
* Parse Webhook
* Event Webhook (Click)
* Template Engine API

This stores the game data and template id to MongoDB.

# System Requirements
* [Ruby](https://www.ruby-lang.org) 2.0.0 or higher
* [Bundler](http://bundler.io/) ([Sinatra](http://www.sinatrarb.com/), [sendgrid_ruby](https://github.com/SendGridJP/sendgrid-ruby),[sendgrid_template_engine](https://github.com/awwa/sendgrid_template_engine_ruby)... See [Gemfile](https://github.com/awwa/sendgrid-reversi/blob/master/Gemfile) for detail)
* [MongoDB](http://www.mongodb.org/)
* [ngrok](https://ngrok.com/) (for local environment)

# Installation & Setup

##### 1. Run the ngrok  
[ngrok](https://ngrok.com/) is easy way to publish your service if you launch the application on local environment.  
'4567' is the port number to tunnel.  
You will see Forwarding URL when you launch ngrok.
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

##### 2. Get the source code from GitHub
``` bash
$ git clone https://github.com/awwa/sendgrid-reversi.git
$ cd sendgrid-reversi
```

##### 3. Run bundle install
``` bash
$ bundle install
```

##### 4. Copy .env file
``` bash
$ cp .env.example .env
```

##### 5. Edit the .env file
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

|Parameters           |Description                          |
|:--------------------|:------------------------------------|
|**SENDGRID_USERNAME**|Your SendGrid username.              |
|**SENDGRID_PASSWORD**|Your SendGrid password.              |
|**APP_URL**          |Your application URL. 'URL Forwarding' value if you use ngrok.     |
|**PARSE_HOST**       |The domain name of receive email.        |
|**MONGO_HOST**       |The host name of mongodb running.    |
|**MONGO_PORT**       |The port number of mongodb listening.|
|**MONGO_DB**         |The name of db. 'reversi' is the default.|
|**MONGO_USERNAME**   |The username of mongodb. remains empty if no need to authenticate.|
|**MONGO_PASSWORD**   |The password of mongodb for access.|

# Launch the application
##### 1. Launch mongod  
``` bash
$ mongod
```
##### 2. Launch Application  
The application setup SendGrid when first time launch. Also start the service to listen.  
``` bash
$ RACK_ENV=production rackup -p 4567
```

# Usage

##### 1. Start a game  
Player1 sends email to any address of PARSE_HOST domain.  
That subject include email address of player2.
``` text
To: game@your.receive.domain
Subject: player2@address.test
```

##### 2. Get an email and click it  
Player2 get an email like this.  
He(she) can click on the email where he(she) want to put disc.
<img src="https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/dev/board_html.png" width="450px" />  
After this, the each player get an email then click it.

##### 3. Pass your turn  
You can click 'Pass your turn' link under the board if you want to pass your turn.  

##### 4. Finish the game  
The game will finish in the case:
  * All cell was filled.
  * Each player continuously clicked the pass link.

##### 5. text/plain part  
You can view text/plain version board email if your email client does not support html mail.
<img src="https://raw.githubusercontent.com/awwa/sendgrid-reversi/master/dev/board_plain.png" width="450px" />  

# Limitation
Do not say 'Create a browser based application'.
This is a demo application. ;-)
