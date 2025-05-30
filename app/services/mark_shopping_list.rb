# frozen_string_literal: true

class MarkShoppingList
  attr_reader :shopping_list, :fridge

  def initialize(shopping_list_id, fridge_id)
    @shopping_list = ShoppingList.find(shopping_list_id)
    @fridge = Fridge.find(fridge_id)
  end

  def call
    fridge.add_ingredients(shopping_list.ingredients)
    shopping_list.update(done: true)
    {
      message: "Shopping list #{shopping_list.id} has been marked as done and ingredients have been added to the fridge",
      fridge_id: fridge.id
    }
  end
end
