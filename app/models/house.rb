class House < ApplicationRecord
    acts_as_paranoid

    has_uid 'house_'

    OWNERSHIP_STATUS = %w[owned mortgaged].freeze

    belongs_to :personal_information

    validates_presence_of :ownership_status
    validate :ownership_status_must_match

    private

    def ownership_status_must_match
        if self.ownership_status && !OWNERSHIP_STATUS.include?(self.ownership_status)
          errors.add(:ownership_status, 'must be owned or mortgaged')
        end
    end
end
  