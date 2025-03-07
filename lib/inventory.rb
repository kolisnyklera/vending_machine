# frozen_string_literal: true

class Inventory
  attr_reader :products

  def initialize
    @products = seed_products
  end

  def find_product(name)
    @products.find { |product| product.name == name }
  end

  def sell_product(name)
    product = find_product(name)
    product.decrease_stock
  end

  private

  def seed_products
    Constants::INVENTORY.map do |name, details|
      Product.new(
        name:,
        price: details[:price],
        quantity: details[:quantity]
      )
    end
  end
end
