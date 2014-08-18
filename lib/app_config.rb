# -*- encoding: utf-8 -*-

require 'mongo'

class AppConfig

  attr_accessor :_id,:template_id_board, :template_id_message

  def initialize
    @_id = BSON::ObjectId.new
    @template_id_board = ""
    @template_id_message = ""
  end

  def to_array
    data = {}
    data["_id"] = @_id
    data["template_id_board"] = @template_id_board
    data["template_id_message"] = @template_id_message
    data
  end

  def self.create_new(data)
    obj = AppConfig.new
    obj._id = data["_id"]
    obj.template_id_board = data["template_id_board"]
    obj.template_id_message = data["template_id_message"]
    obj
  end

end
