class DeviceModel < ApplicationRecord
  # Associations
  has_many :devices
  has_and_belongs_to_many :remotes
  ## ensures all the model's remotes are valid as well
  validates_associated :remotes, message: "%{value} emote for this device isn't configured properly."
  
  # Validations
  ## mirror db validations in the model
  VALID_BRAND_REGEX = /\A[\w ]+\z/
  VALID_BRANDS = %w(Samsung
                    Sony
                   )
  validates :brand,
              format: { with: VALID_BRAND_REGEX },
              inclusion: { in: VALID_BRANDS },
              length: { in: 2..50 },
              presence: true
  VALID_DEVICE_TYPE_REGEX = /\A[a-zA-Z -]+\z/
  ## array of valid types, should match types on Alexa skill
  VALID_DEVICE_TYPES = %w(tv
                          sound\ system
                          media\ player
                         )
  validates :device_type,
              format: { with: VALID_DEVICE_TYPE_REGEX },
              inclusion: { in: VALID_DEVICE_TYPES,
                           message: "%{value} is not a valid device type"},
              length: { in: 2..50 },
              presence: true
  VALID_MODEL_REGEX = /\A[\w -_.]+\z/
  validates :model,
              format: { with: VALID_MODEL_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :brand,
                            message: "-#{:brand} already exists in database" }
end
