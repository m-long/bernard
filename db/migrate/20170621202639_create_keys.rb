class CreateKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :keys do |t|
      t.string :name,  null: false, limit: 50
      t.string :value, null: false, limit: 16

      # Don't allow duplicate keys
      t.index [:name, :value], unique: true

      t.timestamps
    end
  end
end
