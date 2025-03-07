# frozen_string_literal: true

module States
  class FinishState < BaseState
    attr_reader :inserted_coins

    def initialize(context, inserted_coins)
      super(context)
      @inserted_coins = inserted_coins
    end

    def handle
      context.cashbox.accept_payment(inserted_coins)
      context.inventory.sell_product(context.product.name)
    end
  end
end
