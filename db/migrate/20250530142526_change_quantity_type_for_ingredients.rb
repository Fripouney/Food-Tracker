class ChangeQuantityTypeForIngredients < ActiveRecord::Migration[8.0]
  def change
    change_column :ingredients, :quantity, :integer
  end
end
