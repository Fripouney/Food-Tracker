# frozen_string_literal: true

class CookRecipe
  attr_reader :fridge, :recipe
  def initialize(fridge, recipe)
    @fridge = fridge
    @recipe = recipe
  end
  def call
    # Vérif paramètres fridge et recipe
    # Récup ingrédients dans recipe
    # Call méthode de fridge pour récupérer les ingrédients manquants
    # Cas où pas d'ingrédient manquant => on enlève la quantité correspondante
    # Cas où il manque des ingrédients => Création d'une shopping list
  end
end

@recipe = Recipe.find(params[:recipe_id])
@fridge = Fridge.find(params[:fridge_id])
missing_ingredients = @fridge.get_missing_ingredients(@recipe.ingredients)
if missing_ingredients.empty?
  @fridge.remove_ingredients(@recipe.ingredients)
  render json: { message: "Recipe has been cooked !" }
else
  # Need to call shopping list creation endpoint but HOW ??
  # This causes a deadlock because API calls itself
  conn = Faraday.new("http://localhost:3000") do |f|
    f.request :json
    f.response :raise_error
    f.adapter Faraday.default_adapter
  end
  payload = {
    name: @recipe.name,
    missing_ingredients: missing_ingredients
  }
  response = conn.post("/shopping_lists", payload)
  # It would be nice if user got a message telling them that they don't have the requred ingredients and that a
  # shopping list has been created automatically because of that (is it possible with an API app ?)
  puts response.body
  render json: response, status: response.status
end
