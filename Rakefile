# frozen_string_literal: true

require 'sequel'
require_relative './support/extra/config'
require_relative './support/initialization'

desc 'Irb with preloaded dependencies and initialization'
task :console do
  sh 'ruby ./support/console.rb'
end

namespace :db do
  return unless %w[development test].include? ENV.fetch('RACK_ENV', 'development')

  desc 'Create databases (development, test, production)'
  task :init do
    Initialization.default_db_connection.tap do |conn|
      conn.run('CREATE DATABASE event_maker_development;')
      conn.run('CREATE DATABASE event_maker_test;')
      conn.run('CREATE DATABASE event_maker_production;')
    end
  end

  desc 'Database migration'
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(
      Initialization.db_connection(Config.settings.db.database),
      'db/migrations', use_transactions: true
    )
  end

  desc 'Seed database'
  task :seed do
    sh 'ruby db/seed.rb'
  end

  desc 'Reset database (drop and recreate database and tables)'
  task :reset do
    Initialization.default_db_connection.tap do |conn|
      conn.run('DROP DATABASE event_maker_development;')
      conn.run('DROP DATABASE event_maker_test;')
      conn.run('DROP DATABASE event_maker_production;')
    end
    Rake::Task['db:init'].invoke
  end
end

namespace :processing do
  desc 'Run asynchronous log files processing'
  task :run do
    require_relative './support/dependencies'

    Job.perform_async
  end
end
