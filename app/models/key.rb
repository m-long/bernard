class Key < ApplicationRecord
  # Associations
  has_and_belongs_to_many :remotes
  
  # Validations
  before_validation :cleanup_whitespace
  ## mirror db validations in the model
  VALID_NAME_REGEX = /\A[\w -]+\z/
  validates :name,
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :value,
                            message: "-value pair already exists" }
  ## value validations
  VALID_HEXIDECIMAL_REGEX = /\A[\d]x[\h]+\z/ # length not validated in REGEX
  validates :value,
              format: { with: VALID_HEXIDECIMAL_REGEX },
              length: { in: 2..16 }, # must be hexidecimal number, max length of 16 chars
              presence: true

  # Private Methods
  private

    # Validation methods
    ## Clean up white space and double spaces
    def cleanup_whitespace
      self.name.squish!
      self.value.squish!
    end
end
