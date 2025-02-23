# frozen_string_literal: true

ActiveAdmin.register Payment do
  permit_params :order_id, :payment_type, :card_number, :full_name

  includes :order

  index do
    selectable_column
    id_column
    column :order do |payment|
      link_to "Order ##{payment.order_id}", admin_order_path(payment.order)
    end
    column :payment_type
    column :full_name
    column :card_number do |payment|
      payment.card_number&.last(4)
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :order, as: :select, collection: proc { Order.pluck(:id, :id) }
  filter :payment_type, as: :select, collection: %w[card cash]
  filter :full_name_cont, label: 'Full Name Contains'
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Payment Details' do
      f.input :order
      f.input :payment_type, as: :select, collection: %w[card cash]
      f.input :full_name
      f.input :card_number
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :order do |payment|
        link_to "Order ##{payment.order_id}", admin_order_path(payment.order)
      end
      row :payment_type
      row :full_name
      row :card_number do |payment|
        payment.card_number&.last(4)
      end
      row :created_at
      row :updated_at
    end

    panel 'Order Information' do
      attributes_table_for payment.order do
        row :username
        row :email
        row :state
        row :total do |order|
          number_to_currency(order.total)
        end
      end
    end
  end
end
