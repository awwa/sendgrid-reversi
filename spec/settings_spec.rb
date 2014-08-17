# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Settings" do

  describe "initialize" do
    it "インスタンス生成検査" do
      settings = Settings.new(".env.example")
      expect(settings.username).to eq("your_username")
      expect(settings.password).to eq("your_password")
      expect(settings.parse_address).to eq("game@rev.awwa500.bymail.in")
      expect(settings.app_host).to eq("http://app.host.example.com")
    end
  end

end
