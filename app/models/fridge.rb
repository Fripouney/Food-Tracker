class Fridge < ApplicationRecord
  validates :name, presence: true
  has_many :ingredients, as: :ingredientable

  def get_missing_ingredients(ingredients)
    all_missing_ingredients = []
    ingredients.each do |ingredient|
      total_quantity = (self.ingredients.select("quantity").where("spoonacular_id = #{ingredient["spoonacular_id"]}").sum(:quantity)).to_i
      if total_quantity < ingredient["quantity"].to_i
        all_missing_ingredients = add_to_array(all_missing_ingredients, ingredient, total_quantity)
      end
    end
    all_missing_ingredients
  end

  # Called when a shopping list is marked as done
  def add_ingredients(ingredients)
    ingredients.each do |ingredient|
      matches = self.ingredients.select {
        |i| i.spoonacular_id == ingredient.spoonacular_id and i.expiration_date == ingredient.expiration_date
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
        remaining_ingredients.concat(rec_compute_remaining_quantities(matches, ingredient.quantity))
      end
      # For each record :
      # # If quantity in record is greater than quantity necessary, then simply subtract the quantity in record
      # # If quantity in record is smaller than necessary quantity, then destroy this record and go to the next one, loop
      # # Looks like a typical recursive method
    end

    remaining_ingredients.each do |updated_ingredient|
      debugger
      self.ingredients.update(updated_ingredient.id, quantity: updated_ingredient.quantity)
    end
  end

  def rec_compute_remaining_quantities(matches, necessary_quantity, index = 0)
    ingredient = matches[index]
    current_quantity = ingredient.quantity
    if current_quantity < necessary_quantity
      ingredient.quantity = 0
      rec_compute_remaining_quantities(matches, necessary_quantity - current_quantity, index + 1)
    elsif current_quantity == necessary_quantity
      ingredient.quantity = 0
      matches
    else
      ingredient.quantity -= necessary_quantity
      matches
    end
  end

  def add_to_array(array, ingredient, base_quantity = 0)
    ingredient_data = {
      spoonacular_id: ingredient["spoonacular_id"],
      name: ingredient["name"],
      quantity: ingredient["quantity"] - base_quantity,
      unit: ingredient["unit"],
      ingredient_type: ingredient["ingredient_type"]
    }
    array << ingredient_data
  end
end
