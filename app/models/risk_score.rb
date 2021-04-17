class RiskScore
    attr_accessor :auto, :disability,  :home, :life
    def initialize(auto, disability, home, life)
        @auto = auto
        @disability = disability
        @home = home
        @life = life
    end
end