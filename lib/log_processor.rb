# frozen_string_literal: true

require './init'

Init.autoload

module LogProcessor
  class Log
    attr_reader :file_name

    def initialize(path)
      @file_name = path
    end

    def lines
      File.readlines(@file_name)
    end
  end

  def processed?(path)
    !ProcessedFile[name: path].nil?
  end

  def processed!(path)
    ProcessedFile.create(name: path)
  end

  def parse_logs
    logs.each do |log|
      next if processed?(log.file_name)

      log.lines.each do |line|
        p process_line line
      end
    end
  end

  private

  def logs
    log_paths.map { |path| Log.new path }
  end

  def process_line(line)
    events = []
    EventRule.all.each do |evt_rule|
      line.scan(/#{evt_rule.pattern}/i).each.with_index do |_, i|
        event = { type: evt_rule.id, time: Time.now }
        evt_rule.attribute_rules_as_hash.each do |attr|
          value = line.scan(/#{attr[:pattern]}/i)[i]
          value = value.is_a?(Array) ? value.join : value
          event[:data] = { attr[:name] => value }
        end
        events << event
      end
    end
    events
  end

  def log_paths
    Dir["#{LOGS_DIR}/*"].select { |f| File.file? f }
  end

  def write_event
    
  end
end
