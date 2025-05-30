class Fridge < ApplicationRecord
  validates :name, presence: true
  has_many :ingredients, as: :ingredientable

  def get_missing_ingredients(ingredients)
    all_missing_ingredients = []
    ingredients.each do |ingredient|
      database_ingredient_records = self.ingredients.includes(:quantity).where(spoonacular_id: :ingredient["spoonacular_id"])
      if database_ingredient_records.empty?
        all_missing_ingredients = add_to_array(all_missing_ingredients, ingredient)
      else
        total_quantity = database_ingredient_records.sum(&:quantity)
        all_missing_ingredients = add_to_array(all_missing_ingredients, ingredient, total_quantity)
      end
    end
    all_missing_ingredients
  end

  # Called when a shopping list is marked as done
  def add_ingredients(ingredients)
    ingredients.each do |ingredient|
      matches = self.ingredients.select {
        |i| i.spoonacular_id == ingredient[:spoonacular_id] and i.expiration_date == ingredient[:expiration_date]
      }
      if matches.empty?
        ingredient_to_add = {
          spoonacular_id: ingredient[:spoonacular_id],
          name: ingredient[:name],
          ingredient_type: ingredient[:ingredient_type],
          quantity: ingredient[:quantity],
          unit: ingredient[:unit],
          expiration_date: ingredient[:expiration_date]
        }
        self.ingredients.insert!(ingredient_to_add)
      else
        matches.first.quantity += ingredient[:quantity].to_i
        self.ingredients.update(matches.first.id, matches.first)
      end
    end
  end

  # Called when a recipe is cooked
  def remove_ingredients(ingredients)
    remaining_ingredients = []
    # Loop on ingredients in parameter
    ingredients.each do |ingredient|
      # For each ingredient there should be at least one record in fridge
      # Order them by expiration date so that ingredients with earliest expiration date are removed first
      matches = self.ingredients.order(:expiration_date).select { |i| i.spoonacular_id == ingredient[:spoonacular_id] }
      unless matches.empty?
        remaining_ingredients.concat(rec_compute_remaining_quantities(matches.as_json, ingredient.quantity))
      end
      # For each record :
      # # If quantity in record is greater than quantity necessary, then simply subtract the quantity in record
      # # If quantity in record is smaller than necessary quantity, then destroy this record and go to the next one, loop
      # # Looks like a typical recursive method
    end
    self.ingredients.update_all(remaining_ingredients)

  end

  def rec_compute_remaining_quantities(matches, necessary_quantity)
    ingredient = matches[0]
    if ingredient.quantity < necessary_quantity
      matches.delete_at(0)
      rec_compute_remaining_quantities(matches, necessary_quantity - ingredient.quantity)
    elsif ingredient.quantity == necessary_quantity
      matches.delete_at(0)
      matches
    else
      ingredient.quantity -= necessary_quantity
    end
  end

  def add_to_array(array, ingredient, base_quantity = 0)
    ingredient_data = {
      spoonacular_id: ingredient["spoonacular_id"],
      name: ingredient["name"],
      quantity: ingredient["quantity"].to_i - base_quantity,
      unit: ingredient["unit"],
      ingredient_type: ingredient["ingredient_type"]
    }
    array << ingredient_data
  end
end
