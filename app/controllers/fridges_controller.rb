class FridgesController < ApplicationController
  def index
    @fridges = Fridge.all
    render json: @fridges
  end

  def create
    unless params[:name].present?
      render json: { error: "Parameter 'name' cannot be blank" }, status: :bad_request
    end

    @fridge = Fridge.new(params[:name])
    if @fridge.save
      render json: @fridge, status: :created
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
