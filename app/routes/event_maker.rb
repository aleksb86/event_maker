# frozen_string_literal: true

class EventMaker < Sinatra::Base
  register Sinatra::Namespace
  helpers Helpers::ViewBuilder
  helpers Helpers::Payload

  set show_exceptions: false
  set raise_errors: false

  before { content_type :json }
  before '/api/v1/event_rules/:id' do
    find_event_rule(params[:id])
  end

  namespace '/api/v1' do
    get '/event_rules' do
      event_rule_data(EventRule, with_attributes: true)
    end

    get '/event_rules/:id' do
      event_rule_data(@event_rule, with_attributes: true)
    end

    post '/event_rules' do
      rule = EventRule.new(json_payload)
      if rule.valid?
        halt 201, event_rule_data(rule) if rule.save
      else
        halt 422, { error: rule.errors }.to_json
      end
    end

    put '/event_rules/:id' do
      @event_rule.set(json_payload)
      if @event_rule.valid?
        event_rule_data(@event_rule) if @event_rule.save
      else
        halt 422, { error: @event_rule.errors }.to_json
      end
    end

    delete '/event_rules/:id' do
      @event_rule.destroy
      status 204
    end
  end

  error Sequel::MassAssignmentRestriction do
    halt 422, { error: env['sinatra.error'].message }.to_json
  end

  error do
    halt 500, { error: 'Unexpected server error' }.to_json
  end

  private

  def find_event_rule(id)
    @event_rule = EventRule[id]
    not_found unless @event_rule
  end
end
