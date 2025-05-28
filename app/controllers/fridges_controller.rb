class FridgesController < ApplicationController
  def index
    @fridges = Fridge.all
    render json: @fridges
  end

  def show
    @fridge = Fridge.find(params[:id])
    render json: {
      id: @fridge.id,
      name: @fridge.name,
      ingredients: @fridge.ingredients
    }
  end

  def create
    unless params[:name].present?
      render json: { error: "Parameter 'name' cannot be blank" }, status: :bad_request
    end

    @fridge = Fridge.new(name: params[:name])
    if @fridge.save
      render json: {
        message: "Fridge created successfully",
        fridge: @fridge
      }
    else
      render json: @fridge.errors, status: :unprocessable_content
    end
  end

  def delete
    unless params[:id].present?
      render json: { error: "Parameter 'id' cannot be blank" }, status: :bad_request
    end

    @fridge = Fridge.find(params[:id])
    @fridge.destroy
    render json: { message: "Fridge successfully deleted" }, status: :ok
  end
end
