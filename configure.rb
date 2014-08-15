require 'sendgrid_template_engine'

module Configure

  TEMP_NAME_BOARD = "reversi_board"
  TEMP_NAME_MESSAGE = "reversi_message"

  def init_sendgrid
    settings = Settings.new
    init_template(settings)
  end

  def init_template(settings)

    dba = AppConfigCollection.new
    appConfig = dba.find_one
    if appConfig == nil then
      # テンプレートIDを保持していなければ、テンプレートを作成する。
      create_template

    else
      # 保存済みのテンプレートIDがあればそのテンプレートを習得する。


    end




  end

  def create_template

    templates = SendgridTemplateEngine::Templates.new(settings.username, settings.password)
    tmps = templates.get_all()
    exist_board = false
    exist_message = false
    tmps.each {|tmp|
      exist_board = true if tmp.name == TEMP_NAME_BOARD
      exist_message = true if tmp.name == TEMP_NAME_MESSAGE
    }




  end


end
