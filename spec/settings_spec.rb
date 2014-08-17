# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Settings" do

  describe "initialize" do
    it "インスタンス生成検査" do
      settings = Settings.new(".env.example")
      expect(settings.username).to eq("your_username")
      expect(settings.password).to eq("your_password")
      expect(settings.app_url).to eq("http://app.host.example.com")
      expect(settings.parse_host).to eq("rev.awwa500.bymail.in")
    end
  end

end
