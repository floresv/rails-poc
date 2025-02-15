class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :ext_id
      t.string :ext_str_category_humb
      t.text :ext_str_category_description

      t.timestamps
    end
  end
end
