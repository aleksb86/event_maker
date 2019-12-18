#\ -p 5000

require_relative './support/dependencies'
require_relative './support/initialization'

Initialization.db_connection(Config.settings.db.database)
# binding.pry

run App
