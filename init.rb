# frozen_string_literal: true

require 'sinatra'
require 'sinatra/sequel'
require 'sinatra/config_file'
require 'sequel'

config_file 'config.yml'

register Sinatra::SequelExtension

LOGS_DIR = settings.app[:logs_dir]
EVENTS_DIR = settings.app[:events_dir]
DB = settings.db[:connection]

configure do
  set :database, DB
end

module Init
  def self.autoload
    %w[models/*.rb lib/*.rb].freeze.each do |path|
      Dir[File.join(File.dirname(__FILE__), path)].each { |file| require file }
    end
  end
end
