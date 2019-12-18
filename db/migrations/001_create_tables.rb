# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:processed_files) do
      primary_key :id
      String :name, null: false
    end

    create_table(:event_rules) do
      primary_key :id
      String :name, null: false
      String :pattern, null: false, unique: true
    end

    create_table(:attribute_rules) do
      primary_key :id
      String :name, null: false
      String :pattern, null: false
      foreign_key :event_rule_id, :event_rules, on_delete: :cascade
      index %i[event_rule_id pattern], unique: true
    end
  end
end
