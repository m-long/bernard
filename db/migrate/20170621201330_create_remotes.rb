class CreateRemotes < ActiveRecord::Migration[5.0]
  def change
    create_table :remotes do |t|
      t.string :name, null: false, limit: 50
      t.string :brand
      t.string :model
      t.string :supported_devices, limit: 50
      t.integer :bits
      t.string :flags
      t.string :include
      t.boolean :manual_sort
      t.integer :suppress_repeat
      t.string :driver
      t.integer :eps,              limit: 1
      t.integer :aeps,             limit: 1
      t.string :header
      t.string :zero
      t.string :one
      t.string :two
      t.string :three
      t.integer :ptrail
      t.integer :plead
      t.string :foot
      t.string :repeat
      t.integer :pre_data_bits
      t.string :pre_data
      t.integer :post_data_bits
      t.string :post_data
      t.string :pre
      t.string :post
      t.integer :gap
      t.integer :repeat_gap
      t.integer :min_repeat
      t.integer :toggle_bit
      t.string :toggle_bit_mask
      t.string :repeat_mask
      t.integer :frequency
      t.integer :duty_cycle,       limit: 1

      t.timestamps
    end
  end
end
