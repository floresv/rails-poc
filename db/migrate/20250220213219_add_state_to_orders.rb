# frozen_string_literal: true

class AddStateToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :state, :string, default: 'pending_of_payment', null: false
  end
end
