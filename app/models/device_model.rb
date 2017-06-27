class DeviceModel < ApplicationRecord
  # Associations
  has_many :devices
  has_and_belongs_to_many :remotes
  belongs_to :device_type
  belongs_to :brand,
               class_name: "DeviceBrand",
               foreign_key: "device_brand_id"
  ## ensures all the model's remotes are valid as well
  validates_associated :remotes, message: "%{value} emote for this device isn't configured properly."
  
  # Validations
  ## mirror db validations in the model
  validates :brand,
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
