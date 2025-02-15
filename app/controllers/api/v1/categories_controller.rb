class API::V1::CategoriesController < API::V1::APIController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized
  def index
    @categories = policy_scope(Category)
    render json: @categories, each_serializer: ::CategorySerializer
  end

  def show
    begin
      @category = Category.find(params[:id])
      render json: @category, serializer: ::CategorySerializer
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Category not found" }, status: :not_found
    end
  end

  def pundit_user
    GuestUser.new
  end
end