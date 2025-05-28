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
