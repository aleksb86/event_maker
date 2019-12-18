# frozen_string_literal: true

class AttributeRule < Sequel::Model
  plugin :validation_helpers
  many_to_one :event_rule

  def validate
    super
    validates_presence %i[pattern name]
    validates_unique %i[event_rule_id name]
  end

  def to_view
    {
      id: id,
      name: name,
      pattern: pattern
    }
  end
end
