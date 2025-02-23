# frozen_string_literal: true

ActiveAdmin.register Meal do
  permit_params :name, :category_id, :price_cents, :image_url

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price do |meal|
      number_to_currency(meal.price)
    end
    column :image_url
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :name
  filter :category
  filter :price_cents
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Meal Details' do
      f.input :name
      f.input :category
      f.input :price
      f.input :image_url
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :category
      row :price do |meal|
        number_to_currency(meal.price)
      end
      row :image_url do |meal|
        image_tag meal.image_url, style: 'max-width: 200px' if meal.image_url.present?
      end
      row :created_at
      row :updated_at
    end
  end
end
