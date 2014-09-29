# -*- encoding: utf-8 -*-

require 'mongo'
require './lib/settings'

class DbAccess

  attr_accessor :db, :coll

  def initialize(coll_name)
    settings = Settings.new
    if settings.mongo_port.length > 0 then
      @connection = Mongo::Connection.new(settings.mongo_host, settings.mongo_port)
    else
      @connection = Mongo::Connection.new(settings.mongo_host)
    end
    @db = @connection.db(settings.mongo_db)
    if settings.mongo_username.length > 0 then
      @db.authenticate(settings.mongo_username, settings.mongo_password)
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
