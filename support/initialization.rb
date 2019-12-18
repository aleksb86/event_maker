# frozen_string_literal: true

module Initialization
  CONNECTION_PARAMS = {
    user: Config.settings.db.user,
    password: Config.settings.db.password,
    host: Config.settings.db.host,
    port: Config.settings.db.port,
    logger: Logger.new($stderr)
  }.freeze

  class << self
    def db_connection(db_name)
      Sequel.postgres(db_name, CONNECTION_PARAMS)
    end

    def default_db_connection
      Sequel.postgres(CONNECTION_PARAMS)
    end
  end
end

# Initialization.db_connect
