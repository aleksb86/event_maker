# frozen_string_literal: true

class EventRule < Sequel::Model
  plugin :validation_helpers
  one_to_many :attribute_rules

  def validate
    super
    validates_presence :pattern
    validates_unique :pattern
  end

  def to_view
    {
      id: id,
      pattern: pattern,
      attribute_rules: attribute_rules.map(&:to_view)
    }
  end

  def attribute_rules_as_hash
    attribute_rules.map { |rule| rule.to_view.slice(:name, :pattern) }
  end
end
