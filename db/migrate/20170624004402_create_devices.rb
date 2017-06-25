class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
      t.string :name,     limit: 50, null: false
      t.references :location,       foreign_key: true, null: false
      t.references :device_model,   foreign_key: true, null: false

      t.index [:name, :location_id], unique: true

      t.timestamps
    end
  end
end
