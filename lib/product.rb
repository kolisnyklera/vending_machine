# frozen_string_literal: true

class Product
  attr_reader :name, :price, :quantity

  def initialize(name:, price:, quantity:)
    @name = name
    @price = price
    @quantity = quantity
  end

  def in_stock?
    quantity.positive?
  end

  def decrease_stock
    @quantity -= 1
  end
end
