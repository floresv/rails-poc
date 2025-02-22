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
FactoryBot.define do
  factory :order do
    username { 'Test User' }
    email { 'test@example.com' }
    total_cents { 1000 }
    state { 'pending_of_payment' }
  end

  factory :order_with_items_and_payment, parent: :order_with_items do
    after(:create) do |order|
      create(:payment, order: order)
    end
  end

  factory :order_with_items, parent: :order do
    after(:create) do |order|
      create_list(:order_item_with_meal, 2, order: order)
    end
  end
end
