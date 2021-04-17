require 'rails_helper'

include ActiveJob::TestHelper

RSpec.describe "PersonalInformationController", type: :request do

    describe "POST #personal_informations" do
        before(:all) do
            Rails.application.load_seed
            ActiveJob::Base.queue_adapter = :test
            # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

            assert PersonalInformation.delete_all
            assert House.delete_all
            assert Vehicle.delete_all
            assert RiskQuestion.delete_all
        end

        it 'should return a risk score' do
            
            params = '{
                "age": 35,
                "dependents": 2,
                "house": {"ownership_status": "owned"},
                "income": 0,
                "marital_status": "married",
                "risk_questions": [0, 1, 0],
                "vehicle": {"year": 2018}
              }'

            post "/personal_informations", params: params,  headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

            expect(response.code).to eq("200")
            expect(response.body).to eq({
                "auto": "regular",
                "disability": "ineligible",
                "home": "economic",
                "life": "regular"
            }.to_json)
        end

        it 'should return a risk score with all ineligible' do
            params = '{
                "age": 61,
                "dependents": 2,
                "income": 0,
                "marital_status": "married",
                "risk_questions": [0, 1, 0]
              }'

            post "/personal_informations", params: params,  headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

            expect(response.code).to eq("200")
            expect(response.body).to eq({
                "auto": "ineligible",
                "disability": "ineligible",
                "home": "ineligible",
                "life": "ineligible"
            }.to_json)
        end
       
        it 'should return a risk score with all responsible' do
            params = '{
                "age": 35,
                "dependents": 2,
                "house": {"ownership_status": "mortgaged"},
                "income": 1,
                "marital_status": "married",
                "risk_questions": [1, 1, 1],
                "vehicle": {"year": 2018}
              }'

            post "/personal_informations", params: params,  headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

            expect(response.code).to eq("200")
            expect(response.body).to eq({
                "auto": "responsible",
                "disability": "responsible",
                "home": "responsible",
                "life": "responsible"
            }.to_json)
        end

        it 'should return error 422 with seven errors messages' do
            params = '{
                "age": -10,
                "dependents": "a",
                "house": {"ownership_status": "none"},
                "income": -10,
                "marital_status": "divorced",
                "risk_questions": [1, 1],
                "vehicle": {"year": -10}
              }'

            post "/personal_informations", params: params,  headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

            expect(response.code).to eq("422")
            response_body = JSON.parse(response.body, symbolize_names: true)
            expect(response_body[:errors].length).to eq(7)
        end
    end
    
end