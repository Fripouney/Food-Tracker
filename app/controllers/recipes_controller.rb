class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render json: @recipes
  end

  def create
    unless params[:name].present? && params[:ingredients].present?
      render json: { error: "Parameters 'name' and 'ingredients' must be set." }, status: :bad_request
    end

    @recipe = Recipe.create(name: params[:name])
    @recipe.ingredients.insert_all(params[:ingredients])
    render json: @recipe
  end
end
