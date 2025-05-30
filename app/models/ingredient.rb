class Ingredient < ApplicationRecord
  belongs_to :ingredientable, polymorphic: true
  after_update :delete_if_no_quantity

  def delete_if_no_quantity
    if self.quantity <= 0
      self.destroy
    end
  end
end
