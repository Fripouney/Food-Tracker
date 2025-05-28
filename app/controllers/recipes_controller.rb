class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: {
      id: @recipe.id,
      name: @recipe.name,
      ingredients: @recipe.ingredients
    }
  end

  def create
    unless params[:name].present? && params[:ingredients].present?
      render json: { error: "Parameters 'name' and 'ingredients' must be set." }, status: :bad_request
    end

    @recipe = Recipe.create(name: params[:name])
    recipe_ingredients = []
    service = SpoonacularService.new
    params[:ingredients].each do |ingredient|
      ingredient_data = {}
      info = service.get_ingredient_information(ingredient["spoonacular_id"])
      ingredient_data[:spoonacular_id] = ingredient["spoonacular_id"]
      ingredient_data[:name] = info["name"]
      ingredient_data[:ingredient_type] = info["aisle"]
      ingredient_data[:quantity] = ingredient["quantity"]
      ingredient_data[:unit] = ingredient["unit"]
      recipe_ingredients << ingredient_data
    end
    @recipe.ingredients.insert_all(recipe_ingredients)
    render json: {
      message: "Recipe created successfully",
      recipe: @recipe
    }
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    render json: { messsage: "Recipe successfully deleted" }, status: :ok
  end

  def cook
    cook_service = CookRecipe.new(params[:fridge_id], params[:recipe_id]).call

    if cook_service[:enough_ingredients]
      render json: { message: "Recipe cooked successfully" }, status: :ok
    else
      render json: { message: "Ingredients missing, shopping list was created", shopping_list_id: cook_service[:shopping_list_id] }, status: :ok
    end
  end
end
