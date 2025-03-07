# frozen_string_literal: true

module States
  class ProcessChangeState < BaseState
    attr_reader :inserted_coins, :inserted_amount

    def initialize(context, inserted_coins, inserted_amount)
      super(context)
      @inserted_coins = inserted_coins
      @inserted_amount = inserted_amount
    end

    def handle
      calculated_change = context.cashbox.calculate_change(context.product.price, inserted_amount)
      coins_for_deduction = calculate_coins(calculated_change, inserted_coins)

      if coins_for_deduction
        process_payment(coins_for_deduction, inserted_coins)
      else
        context.can_provide_change = false
        context.user_interface.not_enough_change(inserted_coins)
      end
    end

    private

    def process_payment(coins_for_deduction, inserted_coins)
      context.cashbox.deduct_coins(coins_for_deduction)

      context.user_interface.change_returned(context.product.name, calculate_coins_to_return(coins_for_deduction))
      transition_to_finish(inserted_coins)
    end

    def transition_to_finish(inserted_coins)
      context.change_state(FinishState.new(context, inserted_coins))
    end

    def calculate_coins(amount, inserted_coins)
      remaining = amount
      change = {}

      available_coins = build_available_coins(inserted_coins)

      coin_values = available_coins.keys

      # coins are already sorted in reverse order due to their position in Constants::MACHINE_COINS
      coin_values.each do |coin_value|
        next if cannot_use_coin?(remaining, coin_value, available_coins)

        num_coins = [remaining / coin_value, available_coins[coin_value]].min.to_i

        change[coin_value] = num_coins
        remaining -= coin_value * num_coins

        break if remaining.zero?
      end

      remaining.zero? ? change : nil
    end

    def cannot_use_coin?(remaining, coin_value, available_coins)
      remaining < coin_value || available_coins[coin_value].zero?
    end

    def build_available_coins(inserted_coins)
      cashbox_coins = context.cashbox.coins
      cashbox_coins.each_with_object(inserted_coins.tally) do |coin, hash|
        hash[coin.value] = coin.quantity
      end
    end

    def calculate_coins_to_return(coins_for_deduction)
      coins_for_deduction.flat_map { |value, count| [value] * count }
    end
  end
end
