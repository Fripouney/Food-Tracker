class Recipe < ApplicationRecord
  validates :name, presence: true
  has_many :ingredients, as: :ingredientable

  # Might be useless
  def add_ingredient(ingredient)
    # TODO
  end
end
