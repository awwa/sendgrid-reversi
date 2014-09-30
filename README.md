sendgrid-reversi
================
The SendGrid-Reversi is an open source demo project.  

[![Build Status](https://travis-ci.org/awwa/sendgrid-reversi.svg?branch=master)](https://travis-ci.org/awwa/sendgrid-reversi)

# How it works

This application is Ruby application to work on Sinatra.  
This uses some of SendGrid APIs.
* Web API(Mail, Filter Settings, Parse Webhook Settings)
* SMTP API(To, Substitutions, Filters)
* Parse Webhook
* Event Webhook (Click)
* Template Engine

This stores the game data and template id to MongoDB.

# System Requirements
* [Ruby](https://www.ruby-lang.org) 2.0.0 or higher
* [Bundler](http://bundler.io/) ([Sinatra](http://www.sinatrarb.com/), [sendgrid_ruby](https://github.com/SendGridJP/sendgrid-ruby),[sendgrid_template_engine](https://github.com/awwa/sendgrid_template_engine_ruby)... See [Gemfile](https://github.com/awwa/sendgrid-reversi/blob/master/Gemfile) for detail)
* [MongoDB](http://www.mongodb.org/)
* [ngrok](https://ngrok.com/) (for local environment)

# Installation, Setup & Launch the application
You have 2 options for launching the application.
You can launch the application on local environment or Heroku.
Heroku is simple way.

### 1. Heroku

##### 1-1. Click Heroku button

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

##### 1-2. Setup the application

|Parameters           |Description                          |
|:--------------------|:------------------------------------|
|**APP_URL**          |Your application URL.                |
|**PARSE_HOST**       |The domain name of receive email.        |

##### 1-3. View the application

Access APP_URL for checking the application launch.
Now you are ready for reversi! Goto Usage.

### 2. Local environment

##### 2-1. Run the ngrok  
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

##### 2-2. Get the source code from GitHub
``` bash
$ git clone https://github.com/awwa/sendgrid-reversi.git
$ cd sendgrid-reversi
```

##### 2-3. Run bundle install
``` bash
$ bundle install
```

##### 2-4. Copy .env file
``` bash
$ cp .env.example .env
```

##### 2-5. Edit the .env file
``` bash
vi .env
SENDGRID_USERNAME=your_username
SENDGRID_PASSWORD=your_password
APP_URL=http://app.host.example.com
PARSE_HOST=your.receive.domain
MONGO_URL=mongodb://user:pass@localhost:27017/reversi_development
```

|Parameters           |Description                          |
|:--------------------|:------------------------------------|
|**SENDGRID_USERNAME**|Your SendGrid username.              |
|**SENDGRID_PASSWORD**|Your SendGrid password.              |
|**APP_URL**          |Your application URL. 'URL Forwarding' value if you use ngrok.     |
|**PARSE_HOST**       |The domain name of receive email.        |
|**MONGO_URL**        |The url of mongodb. ex.  mongodb://user:pass@localhost:27017/reversi_development   |

##### 2-6. Launch mongod  
``` bash
$ mongod
```
##### 2-7. Launch Application  
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
