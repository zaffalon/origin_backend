class RiskScoreService

    MORTGAGED = "mortgaged"
    MARRIED = "married"
    INELIGIBLE = "ineligible"
    ECONOMIC = "economic"
    REGULAR = "regular"
    RESPONSIBLE = "responsible"

    def self.calculate_risk(personal_information)
        risk_question = personal_information.risk_questions.first
        risk_points = RiskPoint.new(
            risk_question.question1.to_i + risk_question.question2.to_i + risk_question.question3.to_i
        )

        case personal_information.age
        when 0..29
            risk_points.auto -= 2
            risk_points.disability -= 2
            risk_points.home -= 2
            risk_points.life -= 2
        when 30..40
            risk_points.auto -= 1
            risk_points.disability -= 1
            risk_points.home -= 1
            risk_points.life -= 1
        end

        if personal_information.income > 200000
            risk_points.auto -= 1
            risk_points.disability -= 1
            risk_points.home -= 1
            risk_points.life -= 1
        end

        if personal_information.houses.first&.ownership_status == MORTGAGED
            risk_points.disability += 1
            risk_points.home += 1
        end

        if personal_information.dependents > 0
            risk_points.disability += 1
            risk_points.life += 1
        end

        if personal_information.marital_status == MARRIED
            risk_points.disability -= 1
            risk_points.life += 1
        end

        if personal_information.vehicles.first and personal_information.vehicles.first.year >= (Date.today.year.to_i - 5)
            risk_points.auto += 1
        end

        risk_score = RiskScore.new(
            map_risk(risk_points.auto),
            map_risk(risk_points.disability),
            map_risk(risk_points.home),
            map_risk(risk_points.life)
        )
        
        risk_score.auto = INELIGIBLE if personal_information.houses.empty?
        risk_score.disability = INELIGIBLE if personal_information.income <= 0
        risk_score.home = INELIGIBLE if personal_information.vehicles.empty?

        if personal_information.age > 60
            risk_score.disability = INELIGIBLE
            risk_score.life = INELIGIBLE
        end

        risk_score
    end

    private

    def self.map_risk(risk_point)
        case risk_point
        when -Float::INFINITY..0
            return ECONOMIC
        when 1..2
            return REGULAR
        when 3..Float::INFINITY
            return RESPONSIBLE
        end
    end
end

class FalseClass; def to_i; 0 end end
class TrueClass; def to_i; 1 end end