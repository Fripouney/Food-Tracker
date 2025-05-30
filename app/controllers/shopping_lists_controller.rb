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
      render json: { error: message }, status: :unprocessable_content
    else
      render json: {
      message: "Shopping List created successfully",
      shopping_list: service_result
    }
    end
  end

  def destroy
    @shopping_list = ShoppingList.find(params[:id])
    if @shopping_list.destroy
      render json: { message: "Shopping List destroyed" }, status: :ok
    else
      render json: { error: "Shopping List not found" }, status: :not_found
    end
  end

  def mark_as_done
    service_result = MarkShoppingList.new(params[:shopping_list_id], params[:fridge_id]).call
    render json: service_result
  end
end
