# frozen_string_literal: true

class VendingMachine
  attr_reader :user_interface, :inventory, :cashbox
  attr_accessor :selected_product

  def initialize
    @inventory = Inventory.new
    @user_interface = UserInterface.new
    @cashbox = Cashbox.new
  end

  def run
    user_interface.welcome
    choose_product
    insert_coins
    start_again
  end

  private

  def choose_product
    user_interface.list_products(@inventory.products)
    loop do
      user_interface.enter_product_name
      @selected_product = inventory.find_product(gets.chomp.to_s)

      next user_interface.wrong_value unless @selected_product

      break if @selected_product.in_stock?

      user_interface.not_in_stock(@selected_product.name)
    end
  end

  def insert_coins
    user_interface.available_coins
    user_interface.insert_coins(@selected_product.price)

    coin_inserter = CoinInserter.new(
      product: @selected_product,
      cashbox: cashbox,
      user_interface: user_interface,
      inventory: inventory
    )
    coin_inserter.call
  end

  def start_again
    user_interface.start_again?
    loop do
      answer = gets.chomp.to_s.downcase

      break if answer == "yes"

      if answer == "no"
        user_interface.goodbye
        user_interface.statistics(cashbox, inventory)
        abort
      else
        user_interface.wrong_value
      end
    end

    run
  end
end
