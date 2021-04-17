class Vehicle < ApplicationRecord
    acts_as_paranoid

    has_uid 'vehi_'

    belongs_to :personal_information

    validates :year, numericality: { greater_than_or_equal_to: 0 }
end
  