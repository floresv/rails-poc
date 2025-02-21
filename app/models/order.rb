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
class Order < ApplicationRecord
  include AASM

  self.ignored_columns += ["total"]

  has_many :order_items, dependent: :destroy
  has_many :meals, through: :order_items

  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true  
  
  accepts_nested_attributes_for :order_items
  
  monetize :total_cents, as: "total"
  
  before_save :calculate_total!

  aasm column: :state do
    state :pending_of_payment, initial: true
    state :paid

    event :pay do
      transitions from: :pending_of_payment, to: :paid
    end
  end

  def calculate_total!
    self.total_cents = order_items.sum { |item| item.total_price_cents }
  end

  def mark_as_paid
    pay! # This will trigger the state transition to 'paid'
  end
end
