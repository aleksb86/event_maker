# frozen_string_literal: true

module FileSource
  class LogFile
    attr_reader :file_path, :file_name

    def initialize(path)
      @file_path = path
      @file_name = File.basename(@file_path)
    end

    def lines
      File.readlines(@file_path)
    end

    def processed?(name)
      !ProcessedFile[name: name].nil?
    end

    def processed!(name)
      ProcessedFile.create(name: name)
    end
  end

  class LogDir
    ABS_PATH = Config.settings.app.source_dirs.logs.freeze
    MAX_FILES_AT_TIME = Config.settings.app.max_files_at_time
    
  end
end
