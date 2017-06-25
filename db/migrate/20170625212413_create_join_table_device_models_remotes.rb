class CreateJoinTableDeviceModelsRemotes < ActiveRecord::Migration[5.0]
  def change
    create_join_table :device_models, :remotes do |t|
      # t.index [:device_model_id, :remote_id]
      # t.index [:remote_id, :device_model_id]
    end
  end
end
