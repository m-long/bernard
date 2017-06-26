class DeviceModel < ApplicationRecord
  # Associations
  has_many :devices
  has_and_belongs_to_many :remotes
  belongs_to :device_type
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
  validates :device_type,
              presence: true
  VALID_MODEL_REGEX = /\A[\w -_.]+\z/
  validates :model,
              format: { with: VALID_MODEL_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :brand,
                            message: "-#{:brand} already exists in database" }
end
