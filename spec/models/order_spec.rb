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

RSpec.describe Order, type: :model do
  let(:meal) { create(:meal, price_cents: 1500) } # Assuming you have a Meal factory
  let(:order) { build(:order, username: "john_doe", email: "john@example.com") }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(order).to be_valid
    end

    it 'is not valid without a username' do
      order.username = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without an email' do
      order.email = nil
      expect(order).to_not be_valid
    end

    it 'is not valid with an invalid email format' do
      order.email = "invalid_email"
      expect(order).to_not be_valid
    end

    it 'is valid with a valid email format' do
      order.email = "john@example.com"
      expect(order).to be_valid
    end

    it 'is not valid without total_cents' do
      order.total_cents = nil
      expect(order).to_not be_valid
    end
  end

  describe 'state machine' do
    it 'is initially in the pending_of_payment state' do
      expect(order.state).to eq('pending_of_payment')
    end

    it 'can transition to paid state' do
      order.save
      order.mark_as_paid
      expect(order.state).to eq('paid')
    end

    it 'cannot transition to paid state if already paid' do
      order.save
      order.mark_as_paid
      expect { order.mark_as_paid }.to raise_error(AASM::InvalidTransition)
    end
  end

  describe '#calculate_total' do
    it 'calculates the total based on order items' do
      order.order_items.build(meal: meal, quantity: 2) # Total should be 3000 cents
      order.calculate_total
      expect(order.total_cents).to eq(3000)
    end
  end
end
