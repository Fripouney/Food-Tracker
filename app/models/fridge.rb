class Fridge < ApplicationRecord
  validates :name, presence: true
  has_many :ingredients, as: :ingredientable

  def add_ingredient(ingredient)
    # TODO
  end

  def remove_ingredient(ingredient)
    # TODO
  end
end
