class AddMoneyRailsToOrderItems < ActiveRecord::Migration[7.2]
  def change
    add_column :order_items, :unit_price_cents, :integer
    add_column :order_items, :unit_price_currency, :string, default: 'USD', null: false
  end
end