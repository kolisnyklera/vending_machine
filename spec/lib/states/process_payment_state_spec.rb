# frozen_string_literal: true

RSpec.describe States::ProcessPaymentState do
  let(:product) { build(:product) }
  let(:cashbox) { build(:cashbox) }
  let(:context) { build(:context, product:, cashbox:) }
  let(:inserted_coins) { [0.5, 2.0] }
  let(:inserted_amount) { inserted_coins.sum }

  subject { described_class.new(context, inserted_coins, inserted_amount) }

  describe "#handle" do
    context "when change is needed" do
      it "switches state to ProcessChangeState" do
        allow(context.cashbox).to receive(:change_needed?) { true }

        expect(context).to receive(:change_state).with(instance_of(States::ProcessChangeState))

        subject.handle
      end
    end

    context "when exact amount was received" do
      before do
        allow(cashbox).to receive(:change_needed?) { false }
      end

      it "prints message to stdout'" do
        expect { subject.handle }.to output("You entered the exact amount! Enjoy #{product.name} :)\n").to_stdout
      end

      it "switches state to FinishState" do
        expect(context).to receive(:change_state).with(instance_of(States::FinishState))

        subject.handle
      end
    end
  end
end
