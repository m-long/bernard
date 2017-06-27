class Remote < ApplicationRecord
  # Associations
  has_and_belongs_to_many :keys
  has_and_belongs_to_many :device_models
  ## ensures all keys with the remote are valid as well
  validates_associated :keys

  # Validations
  ## mirror db validations in the model
  VALID_NAME_REGEX = /\A[\w -]+\z/
  validates :name, 
              format: { with: VALID_NAME_REGEX },
              length: { in: 2..50 },
              presence: true
  VALID_BRAND_REGEX = /\A[\w -]+\z/
  validates :brand, 
              format: { with: VALID_BRAND_REGEX },
              length: { in: 2..50 },
              presence: true
  VALID_MODEL_REGEX = /\A[\w -]+\z/
  validates :model,
              format: { with: VALID_MODEL_REGEX },
              length: { in: 2..50 },
              presence: true,
              uniqueness: { scope: :brand,
                            message: "Remote already exists." }
  ## ideally should create HABTM for device_models relation rather than string
  VALID_DEVICE_REGEX = /\A[a-zA-Z ]+\z/
  validates :supported_devices,
              allow_nil: true,
              format: { with: VALID_DEVICE_REGEX },
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
  ## custom validator for flags
  validate :flags_are_formatted_properly

  # Private methods

  private

    def flags_are_formatted_properly
      allowed_flags = %w( RC5
                          RC6
                          RCMM
                          SHIFT_ENC
                          SPACE_ENC
                          REVERSE
                          NO_HEAD_REP
                          NO_FOOT_REP
                          CONST_LENGTH
                          RAW_CODES
                          REPEAT_HEADER
      )
      unless self.flags.blank?
        # validate flags are allowed
        flag_array = self.flags.split("|")
        # make sure no repeated flags
        flag_array.each do |flag|
          flag.squish!
        end
        flag_array.uniq! # remove any duplicate flags
        # validate all flags are allowed, must be case-sensitive
        flag_array.each do |flag|
          unless flag.in? allowed_flags
            errors.add(:flags, "has improper flag: #{flag}")
          end
        end
        # Clean and rebuild flag string
        self.flags = flag_array.join(' | ')
      end
    end
end
