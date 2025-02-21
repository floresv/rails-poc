class API::V1::OrdersController < API::V1::APIController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def index
    @orders = policy_scope(Order)
      .includes(order_items: :meal)
      .order(created_at: :desc)
      .page(params[:page])
      .per(params[:per_page])

    render json: {
      orders: ActiveModelSerializers::SerializableResource.new(@orders),
      pagination: {
        current_page: @orders.current_page,
        next_page: @orders.next_page,
        prev_page: @orders.prev_page,
        total_pages: @orders.total_pages,
        total_count: @orders.total_count
      }
    }, status: :ok
  end

  def show
    @order = policy_scope(Order).includes(order_items: :meal).find(params[:id])
    render json: @order, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Order not found" }, status: :not_found
  end

  def create
    order_creation_service = OrderCreationService.new(order_params)

    begin
      @order = order_creation_service.call
      render json: {
        id: @order.id,
        username: @order.username,
        email: @order.email,
        total: @order.total.format,
        created_at: @order.created_at
      }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  def destroy
    @order = policy_scope(Order).find(params[:id])
    
    if @order.email == params[:email]
      @order.destroy
      render json: { message: "Order successfully deleted" }, status: :ok
    else
      render json: { errors: "Email verification failed" }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Order not found" }, status: :not_found
  end

  def pay
    @order = Order.find(params[:id])

    if @order.state == 'paid'
      render json: { errors: "Order is already paid." }, status: :unprocessable_entity
      return
    end

    if @order.mark_as_paid
      render json: { message: "Order successfully paid" }, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: "Order not found" }, status: :not_found
  end

  private

  def order_params
    params.require(:order).permit(
      :username, 
      :email,
      order_items_attributes: [:meal_id, :quantity]
    )
  end

  def pundit_user
    GuestUser.new
  end
end
