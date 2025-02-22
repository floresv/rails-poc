class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :payment_type, null: false
      t.string :card_number
      t.string :full_name
      
      t.timestamps
    end
  end
end