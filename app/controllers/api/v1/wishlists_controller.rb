# frozen_string_literal: true

module API
  module V1
    class WishlistsController < API::V1::APIController
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized
      before_action :set_wishlist, only: [:destroy]

      def index
        @wishlists = policy_scope(Wishlist)
                     .includes(:wishlistable)
                     .page(params[:page])
                     .per(params[:per_page] || 10)

        render json: @wishlists,
               each_serializer: ::WishlistSerializer,
               meta: pagination_meta(@wishlists)
      end

      def create
        @wishlist = Wishlist.new(wishlist_params)

        if @wishlist.save
          render json: @wishlist, serializer: ::WishlistSerializer, status: :created
        else
          render json: { errors: @wishlist.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @wishlist.destroy
          head :no_content
        else
          render json: { errors: @wishlist.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_wishlist
        @wishlist = Wishlist.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Wishlist not found' }, status: :not_found
      end

      def wishlist_params
        params.require(:wishlist).permit(:wishlistable_type, :wishlistable_id)
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count,
          per_page: collection.limit_value
        }
      end

      def pundit_user
        GuestUser.new
      end
    end
  end
end
