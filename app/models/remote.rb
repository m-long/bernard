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
      flags = flags.split("|").strip
      # make sure no repeated flags
      if flags.unique != flags
        errors.add(:flags, "must not have repeated flags")
      end
      # validate all flags are allowed, must be case-sensitive
      flags.each do |flag|
        unless flag.in? allowed_flags
          errors.add(:flags, "has improper flag: #{flag}")
        end
      end
    end
end
