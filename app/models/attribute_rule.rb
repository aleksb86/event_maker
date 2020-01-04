# frozen_string_literal: true

class AttributeRule < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  plugin :timestamps

  many_to_one :event_rule

  def validate
    super
    validates_presence %i[pattern name]
    validates_unique %i[event_rule_id name]
  end
end
