# frozen_string_literal: true

module API
  module V1
    class MealsController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def index
        @meals = fetch_meals
        render_meals_response
      end

      def show
        @meal = Meal.find(params[:id])
        render json: @meal, serializer: ::MealSerializer
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Meal not found' }, status: :not_found
      end

      private

      def fetch_meals
        meals = policy_scope(Meal)
        meals = meals.where(category_id: params[:category_id]) if params[:category_id].present?
        meals = apply_sorting(meals)
        meals.page(params[:page]).per(params[:per_page] || 9)
      end

      def apply_sorting(meals)
        case params[:sort_by]
        when 'price'
          meals.order(price_cents: sort_direction)
        when 'name'
          meals.order(name: sort_direction)
        else
          meals.order(:price_cents) # default sorting
        end
      end

      def sort_direction
        params[:direction]&.downcase == 'desc' ? :desc : :asc
      end

      def render_meals_response
        render json: @meals,
               each_serializer: ::MealSerializer,
               meta: pagination_meta
      end

      def pagination_meta
        {
          current_page: @meals.current_page,
          total_pages: @meals.total_pages,
          total_count: @meals.total_count,
          per_page: @meals.limit_value
        }
      end

      def pundit_user
        GuestUser.new
      end
    end
  end
end
