class Key < ApplicationRecord

  # Associations
  has_and_belongs_to_many :remote
  
  # Validations
  ## mirror db validations in the model
  validates :name,
              presence: true
  validates :value,
              presence: true
end
