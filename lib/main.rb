# -*- encoding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require './lib/game_collection'
require './lib/addresses'
require './lib/mailer'
require './lib/game'
require './lib/settings'
require './lib/configure'

module Reversi
  class Main < Sinatra::Base
    configure :production do
      begin
        settings = Settings.new
        Configure.init_sendgrid(settings)
      rescue => e
        puts e.backtrace
        puts e.inspect
      end
    end

    post '/game' do
      begin
        # parse email address from request
        from = Addresses.get_address(params[:from])
        to = Addresses.get_address(params[:subject])

        # fail to parse address if it is nil
        mailer = Mailer.new
        if from != nil && to == nil then
          logger.info "Failed to parse opponent player email address. Subject must include email address."
          return 'Fail to parse to address'
        end
        logger.info "from: #{from} to: #{to}"
        if from == nil && to == nil then
          logger.info "Failed to parse email address. Please check the request."
          logger.info "from: #{params[:from]}"
          logger.info "subject: #{params[:subject]}"
          return 'Fail to parse to and from address'
        end
        # get game data from DB
        dba = GameCollection.new
        game = dba.find(from, to)
        # create game data if not exist
        if game == nil then
          game = Game.new
          # odd:first move:black
          game.player_odd = to
          # even:second move:white
          game.player_even = from
          id = dba.insert(game)
          game = dba.findById(id)
          #puts "create new game"
          logger.info "create new game"
        end

        # send email for each player
        logger.info "game._id: #{game._id}"
        mailer.send(game)
      rescue => e
        puts e.inspect
        logger.error e.backtrace
        logger.error e.inspect
      end

      'Success'
    end

    post '/event' do
      begin
        request.body.rewind
        data = JSON.parse(request.body.read)
        data.each{|event|
          begin
            dba = GameCollection.new
            # handle only click event
            next if event['event'] != "click"
            logger.info "got click event"
            # requester address
            email = event['email']
            # parse the url clicked by user
            event_data = Game.parse_cell_url(event['url'])
            # validate the event data
            game = dba.findById(BSON::ObjectId.from_string(event_data["obj_id"]))
            if game == nil then
              logger.info "Could not find valid game. The event was ignored."
              break
            end
            if game.turn != event_data['turn'] then
              logger.info "Invalid turn event."
              break;
            end
            # handle turn
            game = game.handle_turn(event_data['row'], event_data['col'])
            # save the game
            dba.update(game)

            mailer = Mailer.new
            if game.is_finish then
              mailer.send_board(game.player_odd, game)
              mailer.send_board(game.player_even, game)
              dba.remove(game._id)
            else
              mailer.send(game)
            end
          rescue => e
            logger.warn e.backtrace
            logger.warn e.inspect
          end
        }
      rescue => e
        logger.error e.backtrace
        logger.error e.inspect
      end

      'Success'
    end

    # Do not handle get event for security
    # User event is handled in post event
    get '/event' do
      'Your request was accepted.'
    end

  end

end
