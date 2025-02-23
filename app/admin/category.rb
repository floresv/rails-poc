# frozen_string_literal: true

ActiveAdmin.register Category do
  permit_params :name, :ext_id, :ext_str_category_humb, :ext_str_category_description

  index do
    selectable_column
    id_column
    column :name
    column :ext_id
    column :ext_str_category_humb do |category|
      if category.ext_str_category_humb.present? && category.ext_str_category_humb.start_with?('http')
        image_tag category.ext_str_category_humb, style: 'max-width: 100px'
      else
        category.ext_str_category_humb
      end
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :name
  filter :ext_id
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
      f.input :ext_id
      f.input :ext_str_category_humb
      f.input :ext_str_category_description, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :ext_id
      row :ext_str_category_humb do |category|
        if category.ext_str_category_humb.present? && category.ext_str_category_humb.start_with?('http')
          image_tag category.ext_str_category_humb, style: 'max-width: 200px'
        else
          category.ext_str_category_humb
        end
      end
      row :ext_str_category_description
      row :created_at
      row :updated_at
    end

    panel 'Meals in this Category' do
      table_for category.meals do
        column :id
        column :name
        column :price do |meal|
          number_to_currency(meal.price)
        end
        column :actions do |meal|
          safe_join([
                      link_to('View', admin_meal_path(meal)),
                      link_to('Edit', edit_admin_meal_path(meal))
                    ], ' | ')
        end
      end
    end
  end
end
