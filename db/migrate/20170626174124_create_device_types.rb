class CreateDeviceTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :device_types do |t|
      t.string :name, limit: 50, null: false

      t.index :name, unique: true

      t.timestamps
    end

    # Add in column to device_model for reference
    add_reference :device_models, :device_type, foreign_key: true
  end
end
