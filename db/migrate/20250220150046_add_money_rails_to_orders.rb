class AddMoneyRailsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :total_cents, :integer
    add_column :orders, :total_currency, :string, default: 'USD', null: false
  end
end