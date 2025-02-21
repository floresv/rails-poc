class API::V1::CategoriesController < API::V1::APIController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  def index
    @categories = policy_scope(Category).order(:name).page(params[:page]).per(params[:per_page] || 10)
    render json: @categories,
           each_serializer: ::CategorySerializer,
           meta: {
             current_page: @categories.current_page,
             total_pages: @categories.total_pages,
             total_count: @categories.total_count,
             per_page: @categories.limit_value
           }
  end

  def show
    begin
      @category = Category.find(params[:id])
      render json: @category, serializer: ::CategorySerializer
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Category not found" }, status: :not_found
    end
  end

  private

  def pundit_user
    GuestUser.new
  end
end