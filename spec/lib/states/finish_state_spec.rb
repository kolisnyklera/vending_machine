# frozen_string_literal: true

RSpec.describe States::FinishState do
  let(:cashbox) { build(:cashbox) }
  let(:inventory) { build(:inventory) }
  let(:product) { inventory.products.first }
  let(:context) { build(:context, cashbox:, inventory:, product:) }
  let(:inserted_coins) { [0.5, 2.0] }

  subject { described_class.new(context, inserted_coins) }

  describe "#handle" do
    it "accepts payment" do
      expect(cashbox).to receive(:accept_payment).with(inserted_coins)

      subject.handle
    end

    it "sells product" do
      expect(inventory).to receive(:sell_product).with(product.name)

      subject.handle
    end
  end
end
