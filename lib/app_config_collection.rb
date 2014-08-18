# -*- encoding: utf-8 -*-

require 'mongo'
require './lib/db_access'

class AppConfigCollection < DbAccess

  def initialize
    super("app_config")
  end

  def find_one
    row = @coll.find_one()
    config = AppConfig.create_new(row) if row != nil
    config
  end

end
