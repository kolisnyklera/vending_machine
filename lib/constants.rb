# frozen_string_literal: true

module Constants
  INVENTORY = {
    "Coca Cola" => { price: 2.0, quantity: 10 },
    "Sprite" => { price: 2.5, quantity: 10 },
    "Fanta" => { price: 2.25, quantity: 10 },
    "Orange Juice" => { price: 3.0, quantity: 10 },
    "Water" => { price: 3.25, quantity: 0 }
  }.freeze

  MACHINE_COINS = {
    5.0 => 5,
    3.0 => 5,
    2.0 => 5,
    1.0 => 5,
    0.5 => 5,
    0.25 => 5
  }.freeze

  VALID_COINS = MACHINE_COINS.keys
end
