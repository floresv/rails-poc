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
class OrderSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :total, :created_at, :updated_at
  has_many :order_items

  def total
    object.total.format
  end
end
