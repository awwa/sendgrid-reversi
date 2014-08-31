# -*- encoding: utf-8 -*-

require 'mongo'
require 'uri'
include Mongo
require './lib/settings'

class DbAccess

  attr_accessor :db, :coll

  def initialize(coll_name)
    settings = Settings.new

    if settings.mongo_url.length > 0 then
      db = URI.parse(settings.mongo_url)
      db_name = db.path.gsub(/^\//, '')

      @connection = Mongo::Connection.new(db.host, db.port)
      @db = @connection.db(db_name)
      if db.user.length > 0 then
        auth = @db.authenticate(db.user, db.password)
      end
    else
      if settings.mongo_port.length > 0 then
        @connection = Mongo::Connection.new(settings.mongo_host, settings.mongo_port)
      else
        @connection = Mongo::Connection.new(settings.mongo_host)
      end
      @db = @connection.db(settings.mongo_db)
      if settings.mongo_username.length > 0 then
        auth = @db.authenticate(settings.mongo_username, settings.mongo_password)
      end
    end

    @coll = @db.collection(coll_name)
  end

  def insert(doc)
    @coll.insert(doc.to_array)
  end

  def update(doc)
    @coll.update({:_id => doc._id}, doc.to_array)
  end

  def remove(id)
    @coll.remove({:_id => id})
  end

  def drop_all
    @coll.drop
  end


end
