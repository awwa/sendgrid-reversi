# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "AppConfigCollection" do
  describe "initialize" do
    it "Validate constructor" do
      dba = AppConfigCollection.new
    end
  end

  describe "drop_all" do
    it "Validate drop all" do
      dba = AppConfigCollection.new
      dba.drop_all
    end
  end

  describe "insert" do
    it "Validate insert" do
      config = AppConfig.new
      dba = AppConfigCollection.new
      dba.drop_all
      id = dba.insert(config)
      expect(id.class.name).to eq("BSON::ObjectId")
      configActual = dba.find_one
      expect(configActual.template_id_board).to eq("")
      expect(configActual.template_id_message).to eq("")
    end
  end

  describe "find_one" do
    it "Validate the case not exist" do
      dba = AppConfigCollection.new
      dba.drop_all
      actual = dba.find_one
      expect(actual).to eq(nil)
    end
    it "Validate the case exist" do
      dba = AppConfigCollection.new
      dba.drop_all
      config = AppConfig.new
      expect_id = dba.insert(config)
      actual = dba.find_one
      expect(actual._id).to eq(expect_id)
    end
  end

end
