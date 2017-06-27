class CreateDeviceModels < ActiveRecord::Migration[5.0]
  def change
    create_table :device_models do |t|
      t.string :model, limit: 50, null: false

      t.timestamps
    end
  end
end
