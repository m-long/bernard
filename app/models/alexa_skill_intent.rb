class AlexaSkillIntent < ApplicationRecord
  # Associations
  has_many :slots, 
             class_name: "AlexaSkillIntentSlot", 
             foreign_key: "alexa_skill_intent_id"
  # Validations
  ## validate that all associated slots are also valid
  validates_associated :slots, message: "%{value} slot for this skill isn't valid."
  ## name validations
  VALID_NAME_REGEX = /\A[\w -'|]+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: true
  ## message validations
  VALID_MESSAGE_REGEX = /\A[\w -'|]+\z/
  validates :message,
              format: { with: VALID_MESSAGE_REGEX },
              length: { in: 2..50 },
              presence: true
  ## voice_response validations
  VALID_VOICE_RESPONSE_REGEX = /\A[\w -'|.?!,]+\z/
  validates :voice_response,
              format: { with: VALID_VOICE_RESPONSE_REGEX },
              length: { in: 2..50 },
              presence: true
end
