# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "SendGrid" do

  describe "parse_set" do
    it "ParseSet検査" do
      begin
        settings = Settings.new
        sendgrid = Sendgrid.new(settings.username, settings.password)
        res_str = sendgrid.parse_set(settings.parse_host, settings.app_url + "/game", 0)
        json_str = JSON.generate(res_str)
        res = JSON.parse(json_str)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end

  describe "activate_app" do
    it "ClickTracking有効化検査" do
      begin
        settings = Settings.new
        sendgrid = Sendgrid.new(settings.username, settings.password)
        res_str = sendgrid.activate_app("clicktrack")
        json_str = JSON.generate(res_str)
        res = JSON.parse(json_str)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end

    it "EventNotification有効化検査" do
      begin
        settings = Settings.new
        sendgrid = Sendgrid.new(settings.username, settings.password)
        res_str = sendgrid.activate_app("eventnotify")
        json_str = JSON.generate(res_str)
        res = JSON.parse(json_str)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end

  describe "filter_setup" do
    it "ClickTracking検査" do
      begin
        filter = FilterSettings.new
        filter.params["name"] = "clicktrack"
        filter.params["enable_text"] = 1

        settings = Settings.new
        sendgrid = Sendgrid.new(settings.username, settings.password)
        res_str = sendgrid.filter_setup(filter)
        json_str = JSON.generate(res_str)
        res = JSON.parse(json_str)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end

    it "EventNotification検査" do
      begin
        settings = Settings.new

        filter = FilterSettings.new
        filter.params["name"] = "eventnotify"
        filter.params["processed"] = 0
        filter.params["dropped"] = 0
        filter.params["deferred"] = 0
        filter.params["delivered"] = 0
        filter.params["bounce"] = 0
        filter.params["click"] = 1
        filter.params["open"] = 0
        filter.params["unsubscribe"] = 0
        filter.params["spamreport"] = 0
        filter.params["url"] = settings.app_host + "/event"

        sendgrid = Sendgrid.new(settings.username, settings.password)
        res_str = sendgrid.filter_setup(filter)
        json_str = JSON.generate(res_str)
        res = JSON.parse(json_str)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end

  end

end
