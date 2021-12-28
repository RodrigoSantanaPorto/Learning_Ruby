class Player

    attr_accessor :name, :questions
    attr_reader :score

    def initialize(name) 
        @name = name
        reset_score()
     end    

    def increment_score()
        @score += 1 
    end

    def reset_score()
        @score = 0
    end 
end