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
      coins_for_deduction = calculate_coins(calculated_change)

      if coins_for_deduction
        transition_to_finish(coins_for_deduction)
      else
        context.no_change = true
        context.user_interface.not_enough_change(inserted_coins)
      end
    end

    private

    def transition_to_finish(coins_for_deduction)
      context.change_state(FinishState.new(context, inserted_coins, coins_for_deduction))
    end

    def calculate_coins(amount)
      remaining = amount
      change = {}

      available_coins = build_available_coins

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

    def build_available_coins
      cashbox_coins = context.cashbox.coins
      cashbox_coins.each_with_object(inserted_coins.tally) do |coin, hash|
        hash[coin.value] = coin.quantity
      end
    end
  end
end
