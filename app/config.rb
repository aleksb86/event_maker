# frozen_string_literal: true

require 'ostruct'
require 'psych'
require 'json'

class Config
  YAML_CONFIG_PATH = File.expand_path("config_#{ENV.fetch('RACK_ENV', 'development')}.yml").freeze

  class << self
    def settings
      @settings ||= load_config(YAML_CONFIG_PATH)
    end

    private

    def load_config(path)
      JSON.parse(Psych.load_file(path).to_json, object_class: OpenStruct)
    end
  end
end
