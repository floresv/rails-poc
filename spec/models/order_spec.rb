# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  username       :string
#  email          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  total_cents    :integer
#  total_currency :string           default("USD"), not null
#  state          :string           default("pending_of_payment"), not null
#
require 'rails_helper'
require 'spec_helper'

RSpec.describe Order do
  let(:meal) { create(:meal, price_cents: 1500) }
  let(:order) { build(:order, username: 'john_doe', email: 'john@example.com') }
  let(:order_with_payment) { create(:order_with_items_and_payment, username: 'john_doe', email: 'john@example.com') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(order).to be_valid
    end

    it 'is not valid without a username' do
      order.username = nil
      expect(order).not_to be_valid
    end

    it 'is not valid without an email' do
      order.email = nil
      expect(order).not_to be_valid
    end

    it 'is not valid with an invalid email format' do
      order.email = 'invalid_email'
      expect(order).not_to be_valid
    end

    it 'is valid with a valid email format' do
      order.email = 'john@example.com'
      expect(order).to be_valid
    end

    it 'is not valid without total_cents' do
      order.total_cents = nil
      expect(order).not_to be_valid
    end
  end

  describe 'state machine' do
    it 'is initially in the pending_of_payment state' do
      expect(order.state).to eq('pending_of_payment')
    end

    it 'can transition to paid state' do
      order_with_payment.save!
      order_with_payment.mark_as_paid
      expect(order_with_payment.state).to eq('paid')
    end

    it 'cannot transition to paid state if already paid' do
      order_with_payment.save!
      order_with_payment.mark_as_paid
      expect { order_with_payment.mark_as_paid }.to raise_error(AASM::InvalidTransition)
    end
  end

  describe '#calculate_total' do
    let(:order) { create(:order, username: 'john_doe', email: 'john@example.com') }

    it 'calculates the total based on order items' do
      order.order_items.create!(meal: meal, quantity: 2, unit_price_cents: meal.price_cents)
      order.calculate_total!
      expect(order.total_cents).to eq(3000)
    end
  end

  describe '#destroy' do
    context 'when order is pending payment' do
      let(:order) { create(:order) }

      it 'allows deletion' do
        expect(order.destroy).to be_truthy
      end
    end

    context 'when order is paid' do
      let(:order) { create(:order) }

      before do
        create(:payment, order: order)
        order.mark_as_paid
      end

      it 'prevents deletion' do
        expect(order.destroy).to be_falsey
      end

      it 'raises an error when using destroy!' do
        expect { order.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end
end
