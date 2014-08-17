# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "AppConfigCollection" do
  describe "initialize" do
    it "初期値検査" do
      dba = AppConfigCollection.new
    end
  end

  describe "dropAll" do
    it "全削除検査" do
      dba = AppConfigCollection.new
      dba.dropAll
    end
  end

  describe "insert" do
    it "挿入検査" do
      config = AppConfig.new
      dba = AppConfigCollection.new
      dba.dropAll
      id = dba.insert(config)
      expect(id.class.name).to eq("BSON::ObjectId")
      configActual = dba.find_one
      expect(configActual.template_id_board).to eq("")
      expect(configActual.template_id_message).to eq("")
    end
  end

  describe "find_one" do
    it "存在しない場合の検査" do
      dba = AppConfigCollection.new
      dba.dropAll
      actual = dba.find_one
      expect(actual).to eq(nil)
    end
    it "存在する場合の検査" do
      dba = AppConfigCollection.new
      dba.dropAll
      config = AppConfig.new
      expect_id = dba.insert(config)
      actual = dba.find_one
      expect(actual._id).to eq(expect_id)
    end
  end

end
