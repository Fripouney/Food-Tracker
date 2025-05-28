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
  def add_ingredients(ingredients)
    # TODO
  end

  def remove_ingredients(ingredients)
    # TODO
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
