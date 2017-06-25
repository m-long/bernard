class CreateJoinTableDevicesDeviceModels < ActiveRecord::Migration[5.0]
  def change
    create_join_table :devices, :device_models do |t|
      # If end up not using has_and_belongs_to_many, this is irrelevant and can be deleted
      # t.index [:device_id, :device_model_id]
      # t.index [:device_model_id, :device_id]
    end
  end
end
