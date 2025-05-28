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
    service_result = CreateShoppingList.new("Shopping List for #{params[:name]}", params[:ingredients]).call
    case service_result
    in { status: :error, message: message }
      render json: { error: message }, status: :unprocessable_entity
    else
      render json: {
      message: "Shopping List created successfully",
      shopping_list: service_result
    }
    end
  end
end
