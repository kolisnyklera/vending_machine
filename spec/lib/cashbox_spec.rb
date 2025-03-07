# frozen_string_literal: true

RSpec.describe Cashbox do # rubocop:disable Metrics/BlockLength
  let(:cashbox) { described_class.new }
  let(:coins) { build_list(:coin, 3) }
  let(:coin) { coins.first }

  before do
    allow(cashbox).to receive(:seed_coins).and_return(coins)
  end

  describe "#valid_coin?" do
    context "when coin is valid" do
      before { stub_const("Constants::VALID_COINS", [coin.value]) }

      it "returns true" do
        expect(cashbox.valid_coin?(coin.value)).to be true
      end
    end

    context "when coin isn't valid" do
      before { stub_const("Constants::VALID_COINS", [coin.value * 2]) }

      it "returns true" do
        expect(cashbox.valid_coin?(coin.value)).to be false
      end
    end

    context "when coin value isn't number" do
      it "returns false" do
        expect(cashbox.valid_coin?("hello")).to be false
      end
    end
  end

  describe "#accept_payment" do
    context "when inserted coins are valid" do
      let(:inserted_coins) { [coin.value, coin.value] }

      it "updates coins quantities in cashbox" do
        expect { cashbox.accept_payment(inserted_coins) }
          .to change { cashbox.coins.find { |c| c.value == coin.value }.quantity }.by(2)
      end

      it "updates total value" do
        expect { cashbox.accept_payment(inserted_coins) }.to(change { cashbox.calculate_total })
      end
    end

    context "when inserted coin is not valid" do
      let(:inserted_coins) { %w[something wrong] }

      it "doesn't update total value" do
        expect { cashbox.accept_payment(inserted_coins) }.not_to(change { cashbox.calculate_total })
      end
    end
  end

  describe "#deduct_coins" do
    context "when change_coins are valid" do
      let(:change_coins) { { coin.value => 1 } }

      it "updates coins quantities in cashbox" do
        expect { cashbox.deduct_coins(change_coins) }
          .to change { cashbox.coins.find { |c| c.value == coin.value }.quantity }.by(-1)
      end

      it "updates total value" do
        expect { cashbox.deduct_coins(change_coins) }.to(change { cashbox.calculate_total })
      end
    end

    context "when change_coins are invalid" do
      let(:change_coins) { { "wrong" => 1 } }

      it "doesn't update total value" do
        expect { cashbox.deduct_coins(change_coins) }.not_to(change { cashbox.calculate_total })
      end
    end
  end
end
