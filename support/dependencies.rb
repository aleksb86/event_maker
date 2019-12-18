# frozen_string_literal: true

require 'bundler'

Bundler.require(:default, ENV.fetch('RACK_ENV', 'development'))

module Dependencies
  ROOT_DIRS = %w[app lib].freeze
  PATHS = %w[
    ./app/models
    ./app/routes
    ./app/service
    ./lib/extract
    ./lib/transform
    ./lib/load
    ./lib/jobs
  ].freeze

  class << self
    def set_load_path
      ROOT_DIRS.each do |dir|
        Dir["#{File.expand_path(dir)}/**/"].each { |sub_dir| $LOAD_PATH << sub_dir }
      end
    end

    def load_core
      require 'app'
      require 'config'
    end

    def do_autoload
      Zeitwerk::Loader.new.tap do |loader|
        PATHS.each do |dir|
          loader.push_dir(File.expand_path(dir))
        end
        loader.setup
      end
    end
  end
end

Dependencies.set_load_path
Dependencies.do_autoload
Dependencies.load_core
