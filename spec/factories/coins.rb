# frozen_string_literal: true

FactoryBot.define do
  sequence(:coin_value, 0) do |n|
    values = [0.25, 0.5, 1.0, 2.0, 3.0, 5.0]
    values[n % values.length]
  end

  factory :coin, class: Coin do
    value { generate(:coin_value) }
    quantity { [*2..10].sample }

    initialize_with { new(value:, quantity:) }
  end
end
