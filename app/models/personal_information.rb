class PersonalInformation < ApplicationRecord
    acts_as_paranoid

    has_uid 'pinfo_'

    has_many :risk_questions
    has_many :houses
    has_many :vehicles

    accepts_nested_attributes_for :risk_questions, allow_destroy: true
    accepts_nested_attributes_for :houses, allow_destroy: true
    accepts_nested_attributes_for :vehicles, allow_destroy: true

    validates :age, numericality: { greater_than_or_equal_to: 0 }
    validates :dependents, numericality: { greater_than_or_equal_to: 0 }
    validates :income, numericality: { greater_than_or_equal_to: 0 }

    validate :marital_status_must_match
    validate :risk_questions_must_be_present

    MARITAL_STATUS = %w[single married].freeze

    private

    def marital_status_must_match
        if self.marital_status && !MARITAL_STATUS.include?(self.marital_status)
          errors.add(:marital_status, 'must be single or married')
        end
    end

    def risk_questions_must_be_present
        if self.risk_questions.empty? or (self.risk_questions.first.question1.nil? or self.risk_questions.first.question2.nil? or self.risk_questions.first.question3.nil?)
          errors.add(:risk_questions, 'must be array with 3 booleans')
        end
    end


end
