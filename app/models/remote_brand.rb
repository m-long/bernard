class RemoteBrand < ApplicationRecord
  # Associations
  has_many :remotes

  # Validations
  VALID_NAME_REGEX = /\A[\w ]+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { message: "Brand already exists" }
end
