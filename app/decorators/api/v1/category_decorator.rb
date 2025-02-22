# frozen_string_literal: true

module API
  module V1
    class CategoryDecorator < Draper::Decorator
      delegate_all
    end
  end
end
