class DeviceType < ApplicationRecord
  # Associations
  has_many :device_models

  # Validations
  VALID_DEVICE_TYPE_REGEX = /\A[a-zA-Z -]+\z/
  ## array of valid types, should match types on Alexa skill
  VALID_DEVICE_TYPES = %w(tv
                          sound\ system
                          media\ player
                          outlet
                          light
                         )
  validates :name,
              format: { with: VALID_DEVICE_TYPE_REGEX },
              inclusion: { in: VALID_DEVICE_TYPES,
                           message: "%{value} is not a valid device type"},
              length: { in: 2..50 },
              presence: true
end
