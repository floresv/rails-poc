# frozen_string_literal: true

class CreateWishlists < ActiveRecord::Migration[7.2]
  def change
    create_table :wishlists do |t|
      t.references :wishlistable, polymorphic: true

      t.timestamps
    end

    add_index :wishlists, [:wishlistable_type, :wishlistable_id], unique: true,
      name: 'index_wishlists_wishlistable'
  end
end