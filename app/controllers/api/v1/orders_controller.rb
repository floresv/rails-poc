# frozen_string_literal: true

module API
  module V1
    class OrdersController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def index
        @orders = fetch_orders
        render_orders_response
      end

      def show
        @order = policy_scope(Order).includes(order_items: :meal).find(params[:id])
        render json: @order, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Order not found' }, status: :not_found
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
        @order = Order.find(params[:id])

        if @order.destroy
          head :no_content
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      def pay
        @order = Order.find(params[:id])
        process_payment
      rescue ActiveRecord::RecordNotFound
        render_not_found
      rescue AASM::InvalidTransition
        render_already_paid
      end

      private

      def fetch_orders
        policy_scope(Order)
          .includes(order_items: :meal)
          .order(created_at: :desc)
          .page(params[:page])
          .per(params[:per_page])
      end

      def render_orders_response
        render json: {
          orders: serialize_orders,
          pagination: pagination_meta
        }, status: :ok
      end

      def serialize_orders
        ActiveModelSerializers::SerializableResource.new(@orders)
      end

      def pagination_meta
        {
          current_page: @orders.current_page,
          next_page: @orders.next_page,
          prev_page: @orders.prev_page,
          total_pages: @orders.total_pages,
          total_count: @orders.total_count
        }
      end

      def order_params
        params.require(:order).permit(
          :username,
          :email,
          order_items_attributes: %i[meal_id quantity]
        )
      end

      def payment_params
        params.require(:payment).permit(:payment_type, :card_number, :full_name)
      end

      def process_payment
        @payment = @order.build_payment(payment_params)

        if save_payment_and_mark_paid
          render_payment_success
        else
          render_payment_errors
        end
      end

      def save_payment_and_mark_paid
        @payment.save && @order.mark_as_paid
      end

      def render_payment_success
        render json: { message: 'Order successfully paid' }, status: :ok
      end

      def render_payment_errors
        errors = @payment.errors.full_messages + @order.errors.full_messages
        render json: { errors: errors }, status: :unprocessable_entity
      end

      def render_not_found
        render json: { errors: 'Order not found' }, status: :not_found
      end

      def render_already_paid
        render json: { errors: 'Order is already paid.' }, status: :unprocessable_entity
      end

      def pundit_user
        GuestUser.new
      end
    end
  end
end
