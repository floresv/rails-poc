# frozen_string_literal: true

module API
  module V1
    class MealDecorator < Draper::Decorator
      delegate_all
    end
  end
end
