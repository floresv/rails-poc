# frozen_string_literal: true

require 'net/http'
require 'json'

seed_admin_user = !AdminUser.exists?
AdminUser.create!(email: 'admin@example.com', password: 'password') if seed_admin_user && Rails.env.development?
seed_setting = !Setting.exists?
Setting.create_or_find_by!(key: 'min_version', value: '0.0') if seed_setting && Rails.env.development?

# Fetch categories
uri = URI('https://www.themealdb.com/api/json/v1/1/categories.php')
response = Net::HTTP.get(uri)

def create_category(category_data)
  Category.find_or_create_by!(id: category_data['idCategory']) do |cat|
    cat.name = category_data['strCategory']
    cat.ext_id = category_data['idCategory']
    cat.ext_str_category_humb = category_data['strCategoryThumb']
    cat.ext_str_category_description = category_data['strCategoryDescription']
    Rails.logger.debug { "Created/Updated category: #{cat.name}" }
  end
end

def calculate_price_cents(category_name)
  case category_name.downcase
  when 'lamb'
    rand(45.00..100.00).round(2) * 100 # Lamb: $45-$100
  when 'beef'
    rand(35.00..80.00).round(2) * 100  # Beef: $35-$80
  when 'pork'
    rand(25.00..60.00).round(2) * 100  # Pork: $25-$60
  else
    rand(10.00..100.00).round(2) * 100 # Other: $10-$100
  end
end

def create_meal(meal_data, category)
  Meal.find_or_create_by(ext_id_meal: meal_data['idMeal']) do |meal|
    meal.name = meal_data['strMeal']
    meal.image_url = meal_data['strMealThumb']
    meal.category = category
    meal.price_cents = calculate_price_cents(category.name)
    Rails.logger.debug { "Created/Updated meal: #{meal.name} (#{meal.price}) for category: #{category.name}" }
  end
end

def process_category(category_data)
  category = create_category(category_data)
  meals_uri = URI("https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category.name}")
  meals_response = Net::HTTP.get(meals_uri)

  begin
    meals_data = JSON.parse(meals_response)
    meals = meals_data['meals']
    meals&.each { |meal_data| create_meal(meal_data, category) }
  rescue JSON::ParserError => e
    Rails.logger.debug { "Error parsing meals JSON for #{category.name}: #{e.message}" }
  rescue StandardError => e
    Rails.logger.debug { "An error occurred fetching meals for #{category.name}: #{e.message}" }
  end
end

begin
  data = JSON.parse(response)
  categories = data['categories']
  categories.each { |category_data| process_category(category_data) }
  Rails.logger.debug 'Category and meal seeding completed!'
rescue JSON::ParserError => e
  Rails.logger.debug { "Error parsing categories JSON: #{e.message}" }
rescue StandardError => e
  Rails.logger.debug { "An error occurred fetching categories: #{e.message}" }
end
