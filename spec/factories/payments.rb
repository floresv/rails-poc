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
FactoryBot.define do
  factory :payment do
    order
    payment_type { 'card' }
    card_number { '4111111111111111' }
    full_name { 'John Doe' }

    trait :cash do
      payment_type { 'cash' }
      card_number { nil }
    end
  end
end
