# frozen_string_literal: true

module States
  class FinishState < BaseState
    attr_reader :inserted_coins, :change_coins

    def initialize(context, inserted_coins, change_coins = nil)
      super(context)
      @inserted_coins = inserted_coins
      @change_coins = change_coins
    end

    def handle
      context.cashbox.accept_payment(inserted_coins)
      context.inventory.sell_product(context.product.name)

      change_coins ? change_message : exact_amount_message
      true
    end

    private

    def change_message
      context.user_interface.change_returned(context.product.name, change_coins)
    end

    def exact_amount_message
      context.user_interface.exact_amount(context.product.name)
    end
  end
end
