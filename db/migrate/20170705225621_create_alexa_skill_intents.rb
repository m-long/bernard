class CreateAlexaSkillIntents < ActiveRecord::Migration[5.1]
  def change
    create_table :alexa_skill_intents do |t|
      t.string :name, limit: 50, null: false
      t.string :message, limit: 50, null: false
      t.string :voice_response, limit: 50, null: false

      t.index :name, unique: true

      t.timestamps
    end
  end
end
