# frozen_string_literal: true

class UserInterface
  def welcome
    puts "Welcome to Vending Machine!"
  end

  def enter_product_name
    puts "\nEnter the desired product name:"
  end

  def list_products(products)
    puts "\nAvailable options:"
    products.each do |product|
      puts "#{product.name} - #{product.price}"
    end
  end

  def wrong_value
    puts "Wrong value entered. Try again!"
  end

  def start_again?
    puts "Do you want to buy something else? (yes/no)"
  end

  def exact_amount(name)
    puts "You entered the exact amount! Enjoy #{name} :)"
  end

  def inserted_not_enough
    puts "You inserted not enough"
  end

  def change_returned(name, coins)
    puts "Here is your change: #{coins.join(', ')}. Enjoy #{name} :)"
  end

  def not_enough_change(coins)
    puts "Unfortunately not enough coins in till for change. Please have your coins back: #{coins.join(', ')}"
  end

  def insert_coins(price)
    puts "You should insert #{price}"
  end

  def available_coins
    puts "Vending machine accepts such coins: #{Constants::VALID_COINS.join(', ')}"
  end

  def not_valid_coin
    puts "Vending machine doesn't accept such coin. Insert the valid one!"
  end

  def not_in_stock(name)
    puts "#{name} is not in stock, select another option!"
  end

  def goodbye
    puts "Till the next time. Goodbye!"
  end

  def statistics(cashbox, inventory)
    puts "\nStatistics!"
    puts "---------------------"
    cashbox.coins.each do |coin|
      puts "Coin value #{coin.value} - qty #{coin.quantity}"
    end
    puts "---------------------"
    puts "Total money in vending machine: #{cashbox.calculate_total}"
    puts "---------------------"
    inventory.products.each do |product|
      puts "#{product.name} - qty in stock #{product.quantity}"
    end
  end
end
