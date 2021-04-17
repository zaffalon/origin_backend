require 'rails_helper'

include ActiveJob::TestHelper

RSpec.describe "RiskScoreService", type: :model do

    describe "POST #personal_informations" do
        before(:all) do
            Rails.application.load_seed
            ActiveJob::Base.queue_adapter = :test

            assert PersonalInformation.delete_all
            assert House.delete_all
            assert Vehicle.delete_all
            assert RiskQuestion.delete_all
        end

        it 'should return a risk score' do
            personal_information = PersonalInformation.create(
                age: 35,
                dependents: 2,
                income: 0,
                marital_status: "married",
                risk_questions_attributes: [
                    question1: 0, question2: 1, question3: 0
                ],
                vehicles_attributes: [
                    year: 2018
                ],
                houses_attributes: [
                    ownership_status: "owned"   
                ]
            )

            response = RiskScoreService.calculate_risk(personal_information)

            expect(response.to_json).to eq({
                "auto": "regular",
                "disability": "ineligible",
                "home": "economic",
                "life": "regular"
            }.to_json)
        end

        it 'should return a risk score with all ineligible' do
            personal_information = PersonalInformation.create(
                age: 61,
                dependents: 2,
                income: 0,
                marital_status: "married",
                risk_questions_attributes: [
                    question1: 0, question2: 1, question3: 0
                ]
            )

            response = RiskScoreService.calculate_risk(personal_information)

            expect(response.to_json).to eq({
                "auto": "ineligible",
                "disability": "ineligible",
                "home": "ineligible",
                "life": "ineligible"
            }.to_json)
        end

        it 'should return a risk score with all ineligible' do
            personal_information = PersonalInformation.create(
                age: 25,
                dependents: 2,
                income: 250000,
                marital_status: "married",
                risk_questions_attributes: [
                    question1: 0, question2: 1, question3: 0
                ],
                vehicles_attributes: [
                    year: 2018
                ],
                houses_attributes: [
                    ownership_status: "owned"   
                ]
            )

            response = RiskScoreService.calculate_risk(personal_information)

            expect(response.to_json).to eq({
                "auto": "economic",
                "disability": "economic",
                "home": "economic",
                "life": "economic"
            }.to_json)
        end

    end
    
end