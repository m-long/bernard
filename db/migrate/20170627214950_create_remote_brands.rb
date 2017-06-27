class CreateRemoteBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :remote_brands do |t|
      t.string :name, limit: 50, null: false

      t.index :name, unique: true

      t.timestamps
    end

    # Add in column to remotes for brand reference
    add_reference :remotes, :remote_brand, foreign_key: true
    add_index :remotes, [:remote_brand_id, :model], unique: true
  end
end
