class ShoppingList < ApplicationRecord
  validates :name, presence: true
  validates :done, inclusion: { in: [ true, false ] }
  has_many :ingredients, as: :ingredientable
end
