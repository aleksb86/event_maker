# frozen_string_literal: true

class ProcessedFile < Sequel::Model
  plugin :json_serializer
  plugin :timestamps
end
