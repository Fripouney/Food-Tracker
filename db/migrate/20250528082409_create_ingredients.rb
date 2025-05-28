class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :type
      t.string :quantity
      t.string :unit
      t.string :expiration_date
      t.references :ingredientable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
