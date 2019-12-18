# frozen_string_literal: true

module Helpers
  module ViewBuilder
    def event_rule_data(dataset, with_attributes: false)
      if with_attributes
        dataset.to_json(include: { attribute_rules: { except: [:event_rule_id] } })
      else
        dataset.to_json
      end
    end
  end
end
