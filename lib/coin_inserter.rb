# frozen_string_literal: true

class CoinInserter
  attr_reader :cashbox, :user_interface, :product, :inventory
  attr_accessor :no_change

  def initialize(product:, cashbox:, inventory:, user_interface:)
    @product = product
    @cashbox = cashbox
    @user_interface = user_interface
    @inventory = inventory
    @no_change = false # default assumption
    @state = States::InsertionState.new(self)
  end

  def call
    @state.handle
  end

  def change_state(new_state)
    @state = new_state
    @state.handle
  end
end
