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
  rescue ActiveRecord::RecordNotFound => e
    raise e
  rescue ActiveRecord::RecordInvalid => e
    raise e
  end

  private

  def verify_meals_exist
    meal_ids = @order_params[:order_items_attributes].map { |item| item[:meal_id] }
    found_meals = Meal.where(id: meal_ids).pluck(:id)
    missing_meals = meal_ids - found_meals

    if missing_meals.any?
      raise ActiveRecord::RecordNotFound, "Meals not found: #{missing_meals.join(', ')}"
    end
  end

  def create_order_items
    @order_params[:order_items_attributes].each do |item|
      meal = Meal.find(item[:meal_id])
      Rails.logger.debug "Creating order item for meal: #{meal.id}, quantity: #{item[:quantity]}, unit_price: #{meal.price}"

      order_item = @order.order_items.build(
        meal: meal,
        quantity: item[:quantity],
        unit_price: meal.price
      )
      
      if order_item.valid?
        order_item.save!
        Rails.logger.debug "Order item created: #{order_item.inspect}"
      else
        Rails.logger.error "Order item is invalid: #{order_item.errors.full_messages.join(', ')}"
      end
    end
  end
end 