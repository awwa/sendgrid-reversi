# -*- encoding: utf-8 -*-

require 'sendgrid_template_engine'
require 'templates'
require './lib/app_config_collection'
require './lib/app_config'
require './lib/sendgrid'

module Configure

  TEMP_NAME_BOARD = "reversi_board"
  TEMP_NAME_MESSAGE = "reversi_message"

  def init_sendgrid(settings)
    Configure.init_template(settings)
    Configure.init_apps(settings)
  end

  def init_apps(settings)
    sendgrid = Sendgrid.new(settings.sendgrid_username, settings.sendgrid_password)

    sendgrid.activate_app("clicktrack")
    sendgrid.activate_app("eventnotify")

    filter_clicktrack = FilterSettings.new
    filter_clicktrack.params["name"] = "clicktrack"
    filter_clicktrack.params["enable_text"] = 1
    sendgrid.filter_setup(filter_clicktrack)

    filter_eventnotify = FilterSettings.new
    filter_eventnotify.params["name"] = "eventnotify"
    filter_eventnotify.params["processed"] = 0
    filter_eventnotify.params["dropped"] = 0
    filter_eventnotify.params["deferred"] = 0
    filter_eventnotify.params["delivered"] = 0
    filter_eventnotify.params["bounce"] = 0
    filter_eventnotify.params["click"] = 1
    filter_eventnotify.params["open"] = 0
    filter_eventnotify.params["unsubscribe"] = 0
    filter_eventnotify.params["spamreport"] = 0
    filter_eventnotify.params["url"] = settings.app_url + "/event"
    sendgrid.filter_setup(filter_eventnotify)

  end

  def init_template(settings)
    dba = AppConfigCollection.new
    appConfig = dba.find_one
    puts "appConfig: #{appConfig.inspect}"
    if appConfig == nil then
      # Create template if no template id
      tmp_id_board, tmp_id_message = Configure.create_template(settings)
      config = AppConfig.new
      config.template_id_board = tmp_id_board
      config.template_id_message = tmp_id_message
      dba.insert(config)
      appConfig = dba.find_one
    end
    appConfig
  end

  def create_template(settings)

    templates = SendgridTemplateEngine::Templates.new(settings.sendgrid_username, settings.sendgrid_password)
    tmps = templates.get_all()
    exist_board = false
    exist_message = false
    tmp_board = nil
    tmp_message = nil
    tmps.each {|tmp|
      if tmp.name == TEMP_NAME_BOARD then
        exist_board = true
        tmp_board = tmp
      end
      if tmp.name == TEMP_NAME_MESSAGE then
        exist_message = true
        tmp_message = tmp
      end
    }

    puts "exist_board: #{exist_board}"
    puts "exist_message: #{exist_message}"

    # Create version
    if !exist_board then
      puts "create template #{TEMP_NAME_BOARD}"
      tmp_board = templates.post(TEMP_NAME_BOARD)
    end
    if !exist_message then
      puts "create template #{TEMP_NAME_MESSAGE}"
      tmp_message = templates.post(TEMP_NAME_MESSAGE)
    end
    versions = SendgridTemplateEngine::Versions.new(settings.sendgrid_username, settings.sendgrid_password)

    new_ver_board = SendgridTemplateEngine::Version.new()
    new_ver_board.set_name("reversi_board_1")
    new_ver_board.set_subject("<%subject%>")
    new_ver_board.set_html_content(open("./template/reversi-board.html").read)
    new_ver_board.set_plain_content(open("./template/reversi-board.txt").read)
    new_ver_board.set_active(1)
    ver_board = versions.post(tmp_board.id, new_ver_board)

    new_ver_message= SendgridTemplateEngine::Version.new()
    new_ver_message.set_name("reversi_message_1")
    new_ver_message.set_subject("<%subject%>")
    new_ver_message.set_html_content(open("./template/reversi-message.html").read)
    new_ver_message.set_plain_content(open("./template/reversi-message.txt").read)
    new_ver_message.set_active(1)
    ver_message = versions.post(tmp_message.id, new_ver_message)

    [tmp_board.id, tmp_message.id]

  end

  module_function :init_sendgrid
  module_function :init_apps
  module_function :init_template
  module_function :create_template


end
