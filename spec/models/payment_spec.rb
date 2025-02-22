# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id           :bigint           not null, primary key
#  order_id     :bigint           not null
#  payment_type :string           not null
#  card_number  :string
#  full_name    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_payments_on_order_id  (order_id)
#
require 'rails_helper'

RSpec.describe Payment do
  describe 'associations' do
    it { is_expected.to belong_to(:order) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:payment_type) }
    it { is_expected.to validate_presence_of(:full_name) }

    context 'when payment_type is card' do
      subject { build(:payment, payment_type: 'card') }

      it { is_expected.to validate_presence_of(:card_number) }
    end

    context 'when payment_type is not card' do
      subject { build(:payment, payment_type: 'cash') }

      it { is_expected.not_to validate_presence_of(:card_number) }
    end
  end

  describe '#card_payment?' do
    context 'when payment_type is card' do
      subject { build(:payment, payment_type: 'card') }

      it 'returns true' do
        expect(subject.send(:card_payment?)).to be true
      end
    end

    context 'when payment_type is not card' do
      subject { build(:payment, payment_type: 'cash') }

      it 'returns false' do
        expect(subject.send(:card_payment?)).to be false
      end
    end
  end
end
