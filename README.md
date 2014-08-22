sendgrid-reversi
================
The SendGrid-Reversi is an open source demo project.  

# System Requirements
* Ruby 2.0.0 or higher
* Bundler
* MongoDB
* ngrok(for local environment)

# Installation & Setup

1. Run the ngrok  
'4567' is the port to tunnel.  
You can get Forwarding URL.
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

1. Get the source code from GitHub
``` bash
$ git clone https://github.com/awwa/sendgrid-reversi.git
$ cd sendgrid-reversi
```

1. Run bundle install
``` bash
$ bundle install
```

1. Copy .env file
``` bash
$ cp .env.example .env
```

1. Edit the .env file
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
|**APP_URL**          |'URL Forwarding' value of ngrok.     |
|**PARSE_HOST**       |Domain name of receive email.        |
|**MONGO_HOST**       |The host name of mongodb running.    |
|**MONGO_PORT**       |The port number of mongodb listening.|
|**MONGO_DB**         |The name of db. 'reversi' is default.|
|**MONGO_USERNAME**   |The username of mongodb. Empty if no need to authenticate.|
|**MONGO_PASSWORD**   |The password of mongodb for access.|

# Launch Application
The application setup SendGrid when first time launch.  

``` bash
$ RACK_ENV=production rackup -p 4567
```

# Usage

1. Start a game  
Player1 sends email to any address of PARSE_HOST domain.  
That subject include email address of player2.
``` text
To: game@your.receive.domain
Subject: player-2@address.test
```
1. Get an email of board and click it   
Player2 get an email like this.  
![Board email](https://raw.github.com/wiki/awwa/sendgrid-reversi/dev/board.png)
Player2 can click on the email where he(she) want to put disc.
