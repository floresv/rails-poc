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
class Payment < ApplicationRecord
  belongs_to :order

  validates :payment_type, presence: true
  validates :card_number, presence: true, if: :card_payment?
  validates :full_name, presence: true

  RANSACK_ATTRIBUTES = %w[
    id
    order_id
    payment_type
    full_name
    created_at
    updated_at
  ].freeze

  def self.ransackable_attributes(_auth_object = nil)
    RANSACK_ATTRIBUTES
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[order]
  end

  private

  def card_payment?
    payment_type == 'card'
  end
end
