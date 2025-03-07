# frozen_string_literal: true

module States
  class FinishState < BaseState
    attr_reader :inserted_coins, :coins_for_deduction

    def initialize(context, inserted_coins, coins_for_deduction = nil)
      super(context)
      @inserted_coins = inserted_coins
      @coins_for_deduction = coins_for_deduction
    end

    def handle
      context.cashbox.accept_payment(inserted_coins)
      context.inventory.sell_product(context.product.name)

      coins_for_deduction ? process_change : exact_amount_message
      true
    end

    private

    def process_change
      context.cashbox.deduct_coins(coins_for_deduction)
      change_coins = context.cashbox.calculate_change_coins(coins_for_deduction)
      context.user_interface.change_returned(context.product.name, change_coins)
    end

    def exact_amount_message
      context.user_interface.exact_amount(context.product.name)
    end
  end
end
