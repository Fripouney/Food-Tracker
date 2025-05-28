class CreateFridges < ActiveRecord::Migration[8.0]
  def change
    create_table :fridges do |t|
      t.string :name

      t.timestamps
    end
  end
end
