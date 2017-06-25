class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false

      t.index [:name, :user_id], unique: true

      t.timestamps
    end
  end
end
