class RiskPoint
    attr_accessor :auto, :disability,  :home, :life
    def initialize(base_point)
        @auto = base_point
        @disability = base_point
        @home = base_point
        @life = base_point
    end
end