# frozen_string_literal: true

class MakeEventsJob < Job
  def perform
    super { puts 'jaba' }
  end
end
