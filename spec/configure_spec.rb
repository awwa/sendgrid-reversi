# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Configure" do

  describe "init_apps" do
    it "Validate initialize application" do
      begin
        settings = Settings.new
        Configure.init_apps(settings)
      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

  describe "manage_template" do
    it "Validate manage templates" do
      begin
        settings = Settings.new
        # delete
        Configure.delete_template(settings, "not exist template")
        Configure.delete_template(settings, Configure::TEMP_NAME_BOARD)
        Configure.delete_template(settings, Configure::TEMP_NAME_MESSAGE)
        # create
        tmp_id_board, tmp_id_message = Configure.create_template(settings)
        expect(tmp_id_board.length).to be > 0
        expect(tmp_id_message.length).to be > 0
        Configure.delete_template(settings, Configure::TEMP_NAME_BOARD)
        Configure.delete_template(settings, Configure::TEMP_NAME_MESSAGE)

      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

  describe "init_template" do
    it "Validate initialize template" do
      begin
        dba = AppConfigCollection.new
        dba.drop_all

        settings = Settings.new
        Configure.delete_template(settings, Configure::TEMP_NAME_BOARD)
        Configure.delete_template(settings, Configure::TEMP_NAME_MESSAGE)


        appConfig = Configure.init_template(settings)
        expect(appConfig.template_id_board.length).to be > 0
        expect(appConfig.template_id_message.length).to be > 0

        appConfig = Configure.init_template(settings)
        expect(appConfig.template_id_board.length).to be > 0
        expect(appConfig.template_id_message.length).to be > 0

      rescue => e
        puts e.inspect
        puts e.backtrace
        raise e
      end
    end
  end

end
