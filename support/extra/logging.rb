# frozen_string_literal: true

require 'logger'

class Logging
  class << self
    def info(message)
      logger.info(message)
    end

    def debug(message)
      logger.debug(message)
    end

    def error(message)
      logger.error(message)
    end

    private

    def logger
      @logger ||= Logger.new(STDOUT) if %w[development test].include? ENV['RACK_ENV']
      @logger ||= Logger.new(File.expand_path('logs/application.log'), 'weekly')
    end
  end
end
