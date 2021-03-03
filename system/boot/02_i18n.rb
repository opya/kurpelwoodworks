Kurpelwoodworks::Application.boot(:i18n) do
  init do
    require 'i18n'

    I18n.load_path << Dir.glob("./config/i18n/**/*.yml")
    I18n.default_locale = :bg
  end
end
