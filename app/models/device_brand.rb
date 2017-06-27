class DeviceBrand < ApplicationRecord
  # Associations
  has_many :models,
             class_name: "DeviceModel",
             foreign_key: "device_brand_id"
  #has_many :devices, through: :models

  # Validations
  VALID_NAME_REGEX = /\A[\w ]+\z/
  VALID_BRANDS = %w(Samsung
                    Sony
                   )
  validates :name,
              format: { with: VALID_NAME_REGEX },
              inclusion: { in: VALID_BRANDS },
              length: { in: 2..50 },
              presence: true,
              uniqueness: true
end
