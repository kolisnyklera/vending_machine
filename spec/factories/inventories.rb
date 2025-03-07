# frozen_string_literal: true

FactoryBot.define do
  factory :inventory, class: Inventory do
    initialize_with { new }
  end
end
