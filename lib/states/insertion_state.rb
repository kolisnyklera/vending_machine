# frozen_string_literal: true

module States
  class InsertionState < BaseState
    def handle
      inserted_amount = 0
      inserted_coins = []

      loop do
        value = gets.chomp.to_f

        unless context.cashbox.valid_coin?(value)
          context.user_interface.not_valid_coin
          next
        end

        inserted_coins << value
        inserted_amount += value

        break if process_completed?(inserted_coins, inserted_amount)

        context.user_interface.inserted_not_enough
      end
    end

    private

    def process_completed?(inserted_coins, inserted_amount)
      return false unless enough_coins?(inserted_amount)

      transition_to_payment(inserted_coins, inserted_amount) || context.no_change
    end

    def enough_coins?(inserted_amount)
      context.cashbox.enough_inserted?(context.product.price, inserted_amount)
    end

    def transition_to_payment(inserted_coins, inserted_amount)
      context.change_state(ProcessPaymentState.new(context, inserted_coins, inserted_amount))
    end
  end
end
