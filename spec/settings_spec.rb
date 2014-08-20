# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Settings" do

  describe "initialize" do
    it "インスタンス生成検査" do
      settings = Settings.new(".env.example")
      expect(settings.sendgrid_username).to eq("your_username")
      expect(settings.sendgrid_password).to eq("your_password")
      expect(settings.app_url).to eq("http://app.host.example.com")
      expect(settings.parse_host).to eq("rev.awwa500.bymail.in")
      expect(settings.mongo_host).to eq("localhost")
      expect(settings.mongo_port).to eq("27017")
      expect(settings.mongo_db).to eq("reversi")
      expect(settings.mongo_username).to eq("")
      expect(settings.mongo_password).to eq("")
    end
  end

end
