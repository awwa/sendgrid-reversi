# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Mailer" do

  describe "send_message" do
    it "メール送信検査" do
      mailer = Mailer.new
      mailer.send_message("awwa500@gmail.com", "メールアドレスが識別できません。")
    end
  end

  describe "send" do
    it "メール送信検査" do
      mailer = Mailer.new
      mailer.send("awwa500@gmail.com", "test_plain", "test_html")
    end
  end
end
