class ShoppingList < ApplicationRecord
  validates :name, presence: true
  validates :done, presence: true
  has_many :ingredients, as: :ingredientable

  def add_ingredient(ingredient)
    # TODO
  end
end
