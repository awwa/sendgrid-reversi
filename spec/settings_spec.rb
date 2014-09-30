# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Settings" do

  describe "initialize" do
    it "Validate constructor" do
      settings = Settings.new(".env.example")
      expect(settings.sendgrid_username).to eq("your_username")
      expect(settings.sendgrid_password).to eq("your_password")
      expect(settings.app_url).to eq("http://app.host.example.com")
      expect(settings.parse_host).to eq("your.receive.domain")
      expect(settings.mongo_url).to eq("mongodb://localhost:27017/reversi_development")
    end
  end

end
