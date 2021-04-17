class RiskQuestion < ApplicationRecord
    acts_as_paranoid

    has_uid 'risk_'

    belongs_to :personal_information
end
  