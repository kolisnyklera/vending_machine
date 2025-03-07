# frozen_string_literal: true

RSpec.describe States::FinishState do
  let(:cashbox) { build(:cashbox) }
  let(:inventory) { build(:inventory) }
  let(:product) { inventory.products.first }
  let(:context) { build(:context, cashbox:, inventory:, product:) }
  let(:inserted_coins) { [0.5, 2.0] }
  let(:coins_for_deduction) { nil }

  subject { described_class.new(context, inserted_coins, coins_for_deduction) }

  describe "#handle" do
    it "accepts payment" do
      expect(cashbox).to receive(:accept_payment).with(inserted_coins)

      subject.handle
    end

    it "sells product" do
      expect(inventory).to receive(:sell_product).with(product.name)

      subject.handle
    end

    it "prints message to stdout'" do
      expect { subject.handle }.to output("You entered the exact amount! Enjoy #{product.name} :)\n").to_stdout
    end

    context "when change_coins are present" do
      let(:coins_for_deduction) { { 3.0 => 1 } }

      it "prints message to stdout'" do
        expect do
          subject.handle
        end.to output("Here is your change: 3.0. Enjoy #{product.name} :)\n").to_stdout
      end
    end
  end
end
