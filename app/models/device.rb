class Device < ApplicationRecord
  # Associations
  belongs_to :location
  belongs_to :device_model
  has_many :remotes, through: :device_model
  has_one :user, through: :location
  
  # Validations
  ## mirror db validations in the model
  VALID_NAME_REGEX = /\A[\w -']+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :location_id,
                            message: "already exists at that location" }
  validates :location_id,
              presence: true
  validates :device_model_id,
              presence: true
end
