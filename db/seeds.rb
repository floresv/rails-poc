# frozen_string_literal: true

require 'net/http'
require 'json'

seed_admin_user = !AdminUser.exists?
if seed_admin_user and Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password')
end
seed_setting = !Setting.exists?
if seed_setting and Rails.env.development?
    Setting.create_or_find_by!(key: 'min_version', value: '0.0')
end

# Fetch categories
uri = URI('https://www.themealdb.com/api/json/v1/1/categories.php')
response = Net::HTTP.get(uri)

begin
  data = JSON.parse(response)
  categories = data['categories']

  categories.each do |category_data|
    category = Category.find_or_create_by(id: category_data['idCategory']) do |cat|
      cat.name = category_data['strCategory']
      cat.ext_id = category_data['idCategory']
      cat.ext_str_category_humb = category_data['strCategoryThumb']
      cat.ext_str_category_description = category_data['strCategoryDescription']
      puts "Created/Updated category: #{cat.name}"
    end

    # Fetch meals for the current category
    meals_uri = URI("https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category.name}")
    meals_response = Net::HTTP.get(meals_uri)

    begin
      meals_data = JSON.parse(meals_response)
      meals = meals_data['meals']

      if meals
        meals.each do |meal_data|
          Meal.find_or_create_by(ext_id_meal: meal_data['idMeal']) do |meal|
            meal.name = meal_data['strMeal']
            meal.image_url = meal_data['strMealThumb']
            meal.category = category

            case category.name.downcase
            when 'lamb'
              meal.price = rand(45.00..100.00).round(2) # Lamb: $45-$100
            when 'beef'
              meal.price = rand(35.00..80.00).round(2)  # Beef: $35-$80
            when 'pork'
              meal.price = rand(25.00..60.00).round(2)  # Pork: $25-$60
            else
              meal.price = rand(10.00..100.00).round(2) # Other: $10-$100
            end
  
            puts "Created/Updated meal: #{meal.name} (#{meal.price}) for category: #{category.name}"
          end
        end
      end

    rescue JSON::ParserError => e
      puts "Error parsing meals JSON for #{category.name}: #{e.message}"
    rescue => e
      puts "An error occurred fetching meals for #{category.name}: #{e.message}"
    end
  end

  puts "Category and meal seeding completed!"

rescue JSON::ParserError => e
  puts "Error parsing categories JSON: #{e.message}"
rescue => e
  puts "An error occurred fetching categories: #{e.message}"
end