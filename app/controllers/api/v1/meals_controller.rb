class API::V1::MealsController < API::V1::APIController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  def index
    @meals = policy_scope(Meal)
    @meals = @meals.where(category_id: params[:category_id]) if params[:category_id].present?
    @meals = @meals.order(:price_cents)
    @meals = @meals.page(params[:page]).per(params[:per_page] || 9)
    
    render json: @meals, 
           each_serializer: ::MealSerializer,
           meta: {
             current_page: @meals.current_page,
             total_pages: @meals.total_pages,
             total_count: @meals.total_count,
             per_page: @meals.limit_value
           }
  end

  def show
    begin
      @meal = Meal.find(params[:id])
      render json: @meal, serializer: ::MealSerializer
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Meal not found" }, status: :not_found
    end
  end

  private

  def pundit_user
    GuestUser.new
  end
end
