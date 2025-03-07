# frozen_string_literal: true

FactoryBot.define do
  factory :context, class: FakeContext do
    cashbox { build(:cashbox) }
    user_interface { build(:user_interface) }
    product { build(:product) }
    inventory { build(:inventory) }

    initialize_with { new(cashbox:, user_interface:, product:, inventory:) }
  end
end
