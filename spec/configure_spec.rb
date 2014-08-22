# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Configure" do

  describe "init_apps" do
    it "Apps設定検査" do
      begin
        settings = Settings.new
        Configure.init_apps(settings)
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end


  describe "create_template" do
    it "テンプレート作成検査" do
      begin
        settings = Settings.new
        tmp_id_board, tmp_id_message = Configure.create_template(settings)
        expect(tmp_id_board.length).to be > 0
        expect(tmp_id_message.length).to be > 0
      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end

  describe "init_template" do
    it "テンプレート初期化検査" do
      begin
        dba = AppConfigCollection.new
        dba.drop_all

        settings = Settings.new
        appConfig = Configure.init_template(settings)
        expect(appConfig.template_id_board.length).to be > 0
        expect(appConfig.template_id_message.length).to be > 0

        appConfig = Configure.init_template(settings)
        expect(appConfig.template_id_board.length).to be > 0
        expect(appConfig.template_id_message.length).to be > 0

      rescue => e
        puts e.inspect
        puts e.backtrace
      end
    end
  end

end
