class Recipe < ApplicationRecord
  validates :name, presence: true
  has_many :ingredients, as: :ingredientable
end
