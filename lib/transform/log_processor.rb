# frozen_string_literal: true

module LogProcessor
  class Log
    attr_reader :file_path, :file_name

    def initialize(path)
      @file_path = path
      @file_name = File.basename(@file_path)
    end

    def lines
      File.readlines(@file_path)
    end
  end

  def processed?(name)
    !ProcessedFile[name: name].nil?
  end

  def processed!(name)
    ProcessedFile.create(name: name)
  end

  def transform_logs
    logs.each do |log|
      next if processed?(log.file_name)

      log.lines.each do |line|
        events = get_events(line)
        write_events(log.file_name, events) unless events.empty?
        processed!(log.file_name)
      end
    end
  end

  private

  def logs
    log_paths.map { |path| Log.new path }
  end

  def get_events(line)
    EventRule.all.map { |evt_rule| parse_events(line, evt_rule) }.flatten
  end

  def parse_events(line, event)
    line.scan(/#{event.pattern}/i).map.with_index do |_, i|
      {
        type: event.id,
        time: Time.now,
        data: parse_attributes(line, i, event.attribute_rules_as_hash)
      }
    end
  end

  def parse_attributes(line, idx, attribute_rules)
    data = {}
    attribute_rules.each do |attr|
      value = line.scan(/#{attr[:pattern]}/i)[idx]
      value = value.is_a?(Array) ? value.join : value
      data[attr[:name]] = value
    end
    data
  end

  def log_paths
    Dir["#{LOGS_DIR}/*"].select { |f| File.file? f }
  end

  def write_events(file_name, events)
    File.open("#{EVENTS_DIR}/#{file_name}", 'w') { |file| events.each { |e| file.puts(e.to_json) } }
  end
end
