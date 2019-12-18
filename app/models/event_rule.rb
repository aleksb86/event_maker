# frozen_string_literal: true

class EventRule < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  plugin :timestamps

  one_to_many :attribute_rules

  def validate
    super
    validates_presence :pattern
    validates_unique :pattern
  end
end
