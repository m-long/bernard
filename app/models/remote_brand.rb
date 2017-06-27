class RemoteBrand < ApplicationRecord
  # Associations
  has_many :remotes

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
