class Ingredient < ApplicationRecord
  belongs_to :ingredientable, polymorphic: true
end
