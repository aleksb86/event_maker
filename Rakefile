# frozen_string_literal: true

require './init'

desc 'Task for basic service initialization'
task :init do
  sh "mkdir -p #{EVENTS_DIR} && mkdir -p #{LOGS_DIR}"
end

namespace :db do
  return unless Sinatra::Application.development? || Sinatra::Application.test?

  desc 'Migration'
  task :migrate do
    sh "sequel -E -m db/migrations #{DB}"
  end

  desc 'Seed database'
  task :seed do
    sh 'ruby db/seed.rb'
  end
end

namespace :processing do
  desc 'Run asynchronous log files processing'
  task :run do
    Init.autoload
    Job.perform_async
  end
end
