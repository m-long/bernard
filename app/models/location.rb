class Location < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :devices, dependent: :destroy

  #Validations
  ## mirror db validations in the model
  VALID_NAME_REGEX = /\A[\w -'|]+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :user_id,
                            message: "device already exists" }
  ## ensures has a user associated with it
  validates :user_id,
              presence: true
end
