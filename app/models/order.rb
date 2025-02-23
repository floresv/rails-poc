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
class Order < ApplicationRecord
  include AASM

  self.ignored_columns += ['total']

  has_many :order_items, dependent: :destroy
  has_many :meals, through: :order_items
  has_one :payment, dependent: :destroy

  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  accepts_nested_attributes_for :order_items

  monetize :total_cents, as: 'total'

  before_save :calculate_total!
  before_destroy :ensure_can_be_deleted

  RANSACK_ATTRIBUTES = %w[
    id
    username
    email
    total_cents
    total_currency
    state
    created_at
    updated_at
  ].freeze

  def self.ransackable_attributes(_auth_object = nil)
    RANSACK_ATTRIBUTES
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[order_items meals payment]
  end

  aasm column: :state do
    state :pending_of_payment, initial: true
    state :paid

    event :pay do
      transitions from: :pending_of_payment, to: :paid
    end
  end

  def mark_as_paid
    return false unless can_be_paid?

    pay! # This will trigger the state transition to 'paid'
  rescue AASM::InvalidTransition => e
    errors.add(:base, e.message)
    raise e
  end

  def calculate_total!
    self.total_cents = order_items.sum(&:total_price_cents)
  end

  private

  def ensure_can_be_deleted
    return true if state == 'pending_of_payment'

    errors.add(:base, I18n.t('activerecord.errors.models.order.attributes.base.cannot_delete_paid'))
    throw(:abort)
  end

  def can_be_paid?
    if payment.nil?
      errors.add(:base, I18n.t('activerecord.errors.models.order.attributes.base.payment_required'))
      return false
    end

    unless payment.persisted?
      errors.add(:base, I18n.t('activerecord.errors.models.order.attributes.base.invalid_payment'))
      return false
    end

    true
  end

  def ensure_can_be_deleted
    return true if state == 'pending_of_payment'

    errors.add(:base, 'Cannot delete a paid order')
    throw(:abort)
  end
end
