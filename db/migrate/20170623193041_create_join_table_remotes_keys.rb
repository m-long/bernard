class CreateJoinTableRemotesKeys < ActiveRecord::Migration[5.0]
  def change
    create_join_table :remotes, :keys do |t|
      # t.index [:remote_id, :key_id]
      # t.index [:key_id, :remote_id]
    end
  end
end
