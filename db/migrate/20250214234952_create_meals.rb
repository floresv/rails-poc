# frozen_string_literal: true

class CreateMeals < ActiveRecord::Migration[7.2]
  def change
    create_table :meals do |t|
      t.integer :category_id
      t.string :ext_str_meal_thumb
      t.integer :ext_id_meal
      t.string :name
      t.string :image_url

      t.timestamps
    end
  end
end
