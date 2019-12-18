# frozen_string_literal: true

require './init'
require 'sinatra/json'

Init.autoload

class EventMaker < Sinatra::Application
  get '/' do
    'This is event maker service'
  end

  get '/event_rules' do
    json EventRule.all.map(&:to_view)
  end

  post '/event_rules' do
    event_rule = EventRule.new(event_params)
    halt 400, json(message: event_rule.errors) unless event_rule.valid?
    event_rule.save
    status 201
  end

  post '/event_rules/:id/attribute_rules' do
    event_rule = EventRule[params[:id]]
    halt 404, json(message: 'Event rule not found') unless event_rule

    attribute_rule = AttributeRule.new(attribute_params)
    halt 400, json(message: attribute_rule.errors) unless attribute_rule.valid?
    attribute_rule.save
    status 201
  end

  get '*' do
    status 404
  end

  post '*' do
    status 404
  end

  private

  def event_params
    body = JSON.parse(request.body.read)
    { pattern: body['pattern'] }
  end

  def attribute_params
    body = JSON.parse(request.body.read)
    { event_rule_id: params[:id], name: body['name'], pattern: body['pattern'] }
  end
end
