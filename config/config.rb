DB = Sequel.connect(ENV['ZOLD_DATABASE'] || 'postgres://postgres:ghbdtn@127.0.0.1:5432/task')
DB.extension(:pagination)
DB.extension(:string_agg)
Sequel.split_symbols = true
DB.extension(:sql_comments)
# DB.logger = Logger.new('zoldlogger', shift_age = 'daily')
DB.logger = Logger.new(STDOUT)
Sequel::Model.db = DB
ROOT = "#{File.dirname(__FILE__)}/.."
HOME = "#{ROOT}/tmp/"
BOT_NAME = 'CRX24'
BOT_NICKNAME = 'CRX24BOT'
$stdout.sync = true
I18n.load_path << "#{ROOT}/locales/ru.yml" << "#{ROOT}/locales/date/ru.yml"
I18n.load_path << "#{ROOT}/locales/en.yml" << "#{ROOT}/locales/date/en.yml"
I18n.backend.load_translations
I18n.locale = :ru
