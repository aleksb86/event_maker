# frozen_string_literal: true

module Helpers
  module Payload
    using GorillaPatch::Symbolize

    def json_payload
      payload = request_data(request).symbolize_keys(deep: true)
      payload
    end

    private

    def request_data(request)
      JSON.parse(request&.body&.read)
    rescue JSON::ParserError
      {}
    end
  end
end
