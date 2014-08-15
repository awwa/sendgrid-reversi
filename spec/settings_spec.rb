# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Settings" do

  describe "initialize" do
    it "インスタンス生成検査" do
      settings = Settings.new(".env.example")
      settings.username.should == "your_username"
      settings.password.should == "your_password"
      settings.parse_address.should == "game@rev.awwa500.bymail.in"
      settings.app_host.should == "http://app.host.example.com"
    end
  end

end
