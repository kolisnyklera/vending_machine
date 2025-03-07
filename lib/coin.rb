# frozen_string_literal: true

class Coin
  attr_reader :value, :quantity

  def initialize(value:, quantity:)
    @value = value
    @quantity = quantity
  end

  def add(value)
    @quantity += value
  end

  def remove(value)
    @quantity -= value
  end
end
