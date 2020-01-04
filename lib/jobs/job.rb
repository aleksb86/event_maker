# frozen_string_literal: true

class Job
  include SuckerPunch::Job
  # include LogProcessor

  def perform
    yield if block_given?
  end
end
