class DeviceBrand < ApplicationRecord
  # Associations
  has_many :models,
             class_name: "DeviceModel",
             foreign_key: "device_brand_id"
  has_many :devices, through: :models

  # Validations
  VALID_NAME_REGEX = /\A[\w ]+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { message: "Brand already exists." }
end
