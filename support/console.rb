# frozen_string_literal: true

require_relative './dependencies'
require_relative './initialization'
require 'irb'

Initialization.db_connection(Config.settings.db.database)
IRB.start
