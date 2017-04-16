# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "SendGrid" do

  describe "parse_set" do
    it "Validate parse set" do
      begin
        settings = Settings.new
        puts settings.sendgrid_username
        sendgrid = Sendgrid.new(settings.sendgrid_username, settings.sendgrid_password)
        res = sendgrid.parse_set(settings.parse_host, settings.app_url + "/game", 0)
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

  describe "activate_app" do
    it "Validate enable ClickTracking" do
      begin
        settings = Settings.new
        sendgrid = Sendgrid.new(settings.sendgrid_username, settings.sendgrid_password)
        res = sendgrid.activate_app("clicktrack")
        expect(res.has_key?("message")).to eq(true)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end

    it "Validate enable EventNotification" do
      begin
        settings = Settings.new
        sendgrid = Sendgrid.new(settings.sendgrid_username, settings.sendgrid_password)
        res = sendgrid.activate_app("eventnotify")
        expect(res.has_key?("message")).to eq(true)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

  describe "filter_setup" do
    it "Validate enable ClickTracking" do
      begin
        filter = FilterSettings.new
        filter.params["name"] = "clicktrack"
        filter.params["enable_text"] = 1

        settings = Settings.new
        sendgrid = Sendgrid.new(settings.sendgrid_username, settings.sendgrid_password)
        res = sendgrid.filter_setup(filter)
        expect(res.has_key?("message")).to eq(true)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end

    it "Validate enable EventNotification" do
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
        filter.params["url"] = settings.app_url + "/event"

        sendgrid = Sendgrid.new(settings.sendgrid_username, settings.sendgrid_password)
        res = sendgrid.filter_setup(filter)
        puts "res: #{res.inspect}"
        expect(res.has_key?("message")).to eq(true)
        expect(res["message"]).to eq("success")
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end

  end

end
