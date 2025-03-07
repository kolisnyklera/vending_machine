# frozen_string_literal: true

FactoryBot.define do
  factory :cashbox, class: Cashbox do
    initialize_with { new }
  end
end
