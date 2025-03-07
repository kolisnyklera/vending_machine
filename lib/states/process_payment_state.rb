# frozen_string_literal: true

module States
  class ProcessPaymentState < BaseState
    attr_reader :inserted_coins, :inserted_amount

    def initialize(context, inserted_coins, inserted_amount)
      super(context)
      @inserted_coins = inserted_coins
      @inserted_amount = inserted_amount
    end

    def handle
      if context.cashbox.change_needed?(context.product.price, inserted_amount)
        context.change_state(ProcessChangeState.new(context, inserted_coins, inserted_amount))
      else
        context.change_state(FinishState.new(context, inserted_coins))
      end
    end
  end
end
