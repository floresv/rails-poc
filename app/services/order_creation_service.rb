# frozen_string_literal: true

class OrderCreationService
  def initialize(order_params)
    @order_params = order_params
    @order = Order.new(order_params.except(:order_items_attributes))
    @order.total_cents = 0
    @order.state = 'pending_of_payment'
  end

  def call
    ActiveRecord::Base.transaction do
      verify_meals_exist
      @order.save!
      create_order_items
      @order.reload
      @order.calculate_total!
      @order.save!
      @order
    end
  end

  private

  def verify_meals_exist
    meal_ids = @order_params[:order_items_attributes].pluck(:meal_id)
    found_meals = Meal.where(id: meal_ids).pluck(:id)
    missing_meals = meal_ids - found_meals

    return unless missing_meals.any?

    raise ActiveRecord::RecordNotFound, "Meals not found: #{missing_meals.join(', ')}"
  end

  def create_order_items
    @order_params[:order_items_attributes].each do |item|
      create_single_order_item(item)
    end
  end

  def create_single_order_item(item)
    meal = Meal.find(item[:meal_id])
    log_order_item_creation(meal, item)
    order_item = build_order_item(meal, item)
    save_order_item(order_item)
  end

  def log_order_item_creation(meal, item)
    Rails.logger.debug do
      "Creating order item for meal: #{meal.id}, quantity: #{item[:quantity]}, unit_price: #{meal.price}"
    end
  end

  def build_order_item(meal, item)
    @order.order_items.build(
      meal: meal,
      quantity: item[:quantity],
      unit_price: meal.price
    )
  end

  def save_order_item(order_item)
    if order_item.valid?
      order_item.save!
      Rails.logger.debug { "Order item created: #{order_item.inspect}" }
    else
      Rails.logger.error "Order item is invalid: #{order_item.errors.full_messages.join(', ')}"
    end
  end
end
