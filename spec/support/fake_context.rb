# frozen_string_literal: true

class FakeContext
  attr_accessor :cashbox, :user_interface, :product, :inventory

  def initialize(cashbox:, user_interface:, product:, inventory:)
    @cashbox = cashbox
    @user_interface = user_interface
    @product = product
    @inventory = inventory
  end

  def change_state(new_state); end
end
