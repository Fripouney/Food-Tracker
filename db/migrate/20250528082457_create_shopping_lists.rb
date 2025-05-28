class CreateShoppingLists < ActiveRecord::Migration[8.0]
  def change
    create_table :shopping_lists do |t|
      t.string :name
      t.boolean :done

      t.timestamps
    end
  end
end
