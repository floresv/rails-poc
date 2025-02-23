# frozen_string_literal: true

ActiveAdmin.register Order do
  permit_params :username, :email, :state,
                order_items_attributes: %i[id meal_id quantity unit_price_cents _destroy]

  scope :all
  scope :pending_of_payment
  scope :paid

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :state
    column :total do |order|
      number_to_currency(order.total)
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :username
  filter :email
  filter :state, as: :select, collection: %w[pending_of_payment paid]
  filter :total_cents
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :username
      row :email
      row :state
      row :total do |order|
        number_to_currency(order.total)
      end
      row :created_at
      row :updated_at
    end

    panel I18n.t('active_admin.orders.panels.order_items') do
      table_for order.order_items do
        column :meal
        column :quantity
        column :unit_price do |item|
          number_to_currency(item.unit_price)
        end
        column :total_price do |item|
          number_to_currency(item.total_price)
        end
      end
    end

    panel I18n.t('active_admin.orders.panels.payment_info') do
      if order.payment.present?
        attributes_table_for order.payment do
          row :payment_type
          row :full_name
          row :card_number do |payment|
            payment.card_number&.last(4)
          end
          row :created_at
        end
      else
        div class: 'blank_slate_container' do
          span class: 'blank_slate' do
            span I18n.t('active_admin.orders.blank_slate.no_payment')
          end
        end
      end
    end
  end

  form do |f|
    f.inputs I18n.t('active_admin.orders.details') do
      f.input :username
      f.input :email
      f.input :state, as: :select, collection: %w[pending_of_payment paid], include_blank: false
    end

    f.inputs I18n.t('active_admin.orders.items') do
      f.has_many :order_items, allow_destroy: true do |item|
        item.input :meal
        item.input :quantity
        item.input :unit_price_cents
      end
    end

    f.actions
  end

  action_item :mark_as_paid, only: :show, if: proc { |order| order.state == 'pending_of_payment' } do
    link_to I18n.t('active_admin.actions.mark_as_paid'),
            mark_as_paid_admin_order_path(order),
            method: :put
  end

  member_action :mark_as_paid, method: :put do
    order = Order.find(params[:id])
    if order.mark_as_paid
      redirect_to admin_order_path(order), notice: I18n.t('active_admin.orders.mark_as_paid.success')
    else
      redirect_to admin_order_path(order), alert: order.errors.full_messages.join(', ')
    end
  end
end
