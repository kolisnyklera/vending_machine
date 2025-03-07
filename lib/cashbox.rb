# frozen_string_literal: true

class Cashbox
  attr_reader :coins

  def initialize
    @coins = seed_coins
  end

  def valid_coin?(value)
    Constants::VALID_COINS.include?(value)
  end

  def accept_payment(inserted_coins)
    inserted_coins.tally.each do |value, counts|
      coin = find_coin(value)
      coin&.add(counts)
    end
  end

  def change_needed?(price, inserted_amount)
    inserted_amount > price
  end

  def enough_inserted?(price, inserted_amount)
    inserted_amount >= price
  end

  def calculate_change(price, inserted_amount)
    inserted_amount - price
  end

  def calculate_total
    @coins.sum { |coin| coin.value * coin.quantity }
  end

  def deduct_coins(change_coins)
    change_coins.each do |value, counts|
      coin = find_coin(value)
      coin&.remove(counts)
    end
  end

  def calculate_change_coins(coins_for_deduction)
    coins_for_deduction.flat_map { |value, count| [value] * count }
  end

  private

  def seed_coins
    Constants::MACHINE_COINS.map do |value, quantity|
      Coin.new(value:, quantity:)
    end
  end

  def find_coin(value)
    @coins.find { |coin| coin.value == value }
  end
end
