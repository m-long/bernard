class DeviceType < ApplicationRecord
  # Associations
  has_many :device_models
  has_many :device_commands

  # Validations
  VALID_DEVICE_TYPE_REGEX = /\A[a-zA-Z -]+\z/
  ## array of valid types, should match types on Alexa skill
  validates :name,
              format: { with: VALID_DEVICE_TYPE_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { message: 'Device type already exists' }
end
