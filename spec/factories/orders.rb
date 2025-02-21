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
    username { "MyString" }
    email { "MyString" }
    total { "9.99" }
  end
end
