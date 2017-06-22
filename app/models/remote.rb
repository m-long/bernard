class Remote < ApplicationRecord
  # Associations
  has_and_belongs_to_many :key
  ## ensures all keys with the remote are valid as well
  validates_associated :key

  # Validations
  ## mirror db validations in the model
  validates :name, 
              presence: true,
              length: { in: 2..50 }
  validates :supported_devices,
              allow_nil: true,
              length: { in: 2..50 }
  validates :eps,
              allow_nil: true,
              inclusion: { in: 0..100 }
  validates :aeps,
              allow_nil: true,
              inclusion: { in: 0..100 }
  validates :duty_cycle,
              allow_nil: true,
              inclusion: { in: 0..100 }
end
