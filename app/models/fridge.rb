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
        self.ingredients.insert(ingredient)
      else
        matches.first.quantity += ingredient[:quantity]
        self.ingredients.update(matches.first.id, matches.first)
      end
    end
  end

  # Called when a recipe is cooked
  def remove_ingredients(ingredients)
    # Loop on ingredients in parameter
    # For each ingredient there should be at least one record in fridge
    # For each record :
    # # If quantity in record is greater than quantity necessary, then simply subtract the quantity in record
    # # If quantity in record is smaller than necessary quantity, then destroy this record and go to the next one, loop
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
