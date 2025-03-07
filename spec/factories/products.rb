# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: Product do
    name { FFaker::Lorem.sentence }
    quantity { [*5..15].sample }
    price { 2.5 }

    initialize_with { new(name: name, price: price, quantity: quantity) }
  end
end
