# frozen_string_literal: true

class PersonalInformationsController < ApplicationController
    before_action do
        set_house_params
        set_vehicle_params
        set_risk_questions
    end

    def create
        @personal_information = PersonalInformation.new(personal_information_params)
        if @personal_information.save
            response = RiskScoreService.calculate_risk(@personal_information)
            render json: response
        else
            render json: ErrorSerializer.serialize(@personal_information), status: :unprocessable_entity
        end
    end

    private

    def personal_information_params
        params.permit(  :age,
                        :dependents,
                        :income,
                        :marital_status,
                        risk_questions_attributes: [
                            :id, :question1, :question2, :question3, :_destroy
                        ],
                        vehicles_attributes: [
                            :id, :year, :_destroy
                        ],
                        houses_attributes: [
                            :id, :ownership_status, :_destroy   
                        ]
                    )
    end

    def set_house_params
        params[:houses_attributes] = []
        params[:houses_attributes] << params[:house] 
    end

    def set_vehicle_params
        params[:vehicles_attributes] = []
        params[:vehicles_attributes] << params[:vehicle]
    end

    def set_risk_questions
        if params[:risk_questions]
            params[:risk_questions_attributes] = [
                {
                    question1: params[:risk_questions][0],
                    question2: params[:risk_questions][1],
                    question3: params[:risk_questions][2]
                }
            ]
        end
    end
    
end