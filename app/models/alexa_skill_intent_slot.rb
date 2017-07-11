class AlexaSkillIntentSlot < ApplicationRecord
  # Associations
  belongs_to :alexa_skill_intent

  # Validations
  ## mirror db validations in the model
  VALID_NAME_REGEX = /\A[\w -'|]+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :alexa_skill_intent_id,
                            message: "slot already exists for this skill" }
  VALID_TEST_VALUE_REGEX = /\A[\w -'|]+\z/
  validates :test_value,
              format: { with: VALID_TEST_VALUE_REGEX },
              length: { in: 1..50 },
              allow_nil: true
  validates :alexa_skill_intent_id,
              presence: true,
              uniqueness: { scope: :name,
                            message: "slot already exists for this skill." }
end
