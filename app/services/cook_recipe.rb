# frozen_string_literal: true

class CookRecipe
  attr_reader :fridge, :recipe

  def initialize(fridge_id, recipe_id)
    @recipe = Recipe.find(recipe_id)
    @fridge = Fridge.find(fridge_id)
  end

  def call
    missing_ingredients = fridge.get_missing_ingredients(recipe.ingredients)

    if missing_ingredients.empty?
      fridge.remove_ingredients(recipe.ingredients)
      { enough_ingredients: true }
    else
      { enough_ingredients: false, shopping_list_id: create_shopping_list_with(missing_ingredients).id }
    end
  end

  private

  def create_shopping_list_with(missing_ingredients)
    list = ShoppingList.create(name: "Shopping List for #{recipe.name}", done: false)
    list.ingredients.insert_all(missing_ingredients)
    list
  end
end
