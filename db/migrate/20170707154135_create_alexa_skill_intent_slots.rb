class CreateAlexaSkillIntentSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :alexa_skill_intent_slots do |t|
      t.string :name, limit: 50, null: false
      t.string :test_value, limit: 50
      t.references :alexa_skill_intent, foreign_key: true

      t.index [:name, :alexa_skill_intent_id], name: "index_name_and_alexa_skill_intent_id", unique: true

      t.timestamps
    end
  end
end
