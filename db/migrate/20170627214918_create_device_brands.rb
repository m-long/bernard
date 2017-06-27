class CreateDeviceBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :device_brands do |t|
      t.string :name, limit: 50, null: false

      t.index :name, unique: true

      t.timestamps
    end

    # Add in column to device_model for brand reference, and make sure brand + model is unique
    add_reference :device_models, :device_brand, foreign_key: true
    add_index :device_models, [:device_brand_id, :model], unique: true
  end
end
