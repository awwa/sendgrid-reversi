# -*- encoding: utf-8 -*-

require 'sendgrid4r'
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

    sendgrid.parse_set(settings.parse_host, settings.app_url + "/game", 0)
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
      Configure.delete_template(settings, Configure::TEMP_NAME_BOARD)
      Configure.delete_template(settings, Configure::TEMP_NAME_MESSAGE)
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
    # Create template
    client = SendGrid4r::Client.new(settings.sendgrid_username, settings.sendgrid_password)
    tmps = client.get_templates
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
      tmp_board = client.post_template(TEMP_NAME_BOARD)
    end
    if !exist_message then
      puts "create template #{TEMP_NAME_MESSAGE}"
      tmp_message = client.post_template(TEMP_NAME_MESSAGE)
    end

    factory = SendGrid4r::VersionFactory.new
    html_content_board = open("./template/reversi-board.html").read
    plain_content_board = open("./template/reversi-board.txt").read
    new_ver_board = factory.create("reversi_board_1", "<%subject%>", html_content_board, plain_content_board, 1)
    client.post_version(tmp_board.id, new_ver_board)

    html_content_message = open("./template/reversi-message.html").read
    plain_content_message = open("./template/reversi-message.txt").read
    new_ver_message = factory.create("reversi_message_1", "<%subject%>", html_content_message, plain_content_message, 1)
    client.post_version(tmp_message.id, new_ver_message)

    [tmp_board.id, tmp_message.id]

  end

  def delete_template(settings, name)
    client = SendGrid4r::Client.new(settings.sendgrid_username, settings.sendgrid_password)
    tmps = client.get_templates
    tmps.each {|tmp|
      if tmp.name == name then
        tmp.versions.each {|ver|
          client.delete_version(tmp.id, ver.id)
          ver.id
        }
        client.delete_template(tmp.id)
      end
    }
  end

  module_function :init_sendgrid
  module_function :init_apps
  module_function :init_template
  module_function :create_template
  module_function :delete_template

end
