class ShoppingListsController < ApplicationController
  def index
    @shopping_lists = ShoppingList.all
    render json: @shopping_lists
  end

  def show
    @shopping_list = ShoppingList.find(params[:id])
    render json: {
      id: @shopping_list.id,
      name: @shopping_list.name,
      ingredients: @shopping_list.ingredients
    }
  end

  def create
    @shopping_list = ShoppingList.create(name: params[:name])
    @shopping_list.ingredients.insert_all(params[:missing_ingredients])
    render json: {
      message: "Shopping List created successfully",
      shopping_list: @shopping_list
    }
  end
end
