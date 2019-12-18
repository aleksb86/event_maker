# frozen_string_literal: true

require 'sucker_punch'
require './lib/log_processor'

class Job
  include SuckerPunch::Job
  include LogProcessor

  def perform

    parse_logs
  end
end
