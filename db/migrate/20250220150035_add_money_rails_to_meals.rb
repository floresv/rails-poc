class AddMoneyRailsToMeals < ActiveRecord::Migration[7.2]
  def change
    add_column :meals, :price_cents, :integer
    add_column :meals, :price_currency, :string, default: 'USD', null: false
  end
end