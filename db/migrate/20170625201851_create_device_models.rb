class CreateDeviceModels < ActiveRecord::Migration[5.0]
  def change
    create_table :device_models do |t|
      t.string :brand, limit: 50, null: false
      # t.string :device_type,  limit: 50, null: false
      t.string :model, limit: 50, null: false

      # Should be a unique device
      t.index [:brand, :model], unique: true

      t.timestamps
    end
  end
end
