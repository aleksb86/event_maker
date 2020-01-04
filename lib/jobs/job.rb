# frozen_string_literal: true

class Job
  include SuckerPunch::Job
  # include LogProcessor

  def perform
    transform_logs
  end
end
