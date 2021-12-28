class Item
    
    def initialize(player) 
        @name_player = player.name
        @score = player.score  
    end

    def name_player
        return @name_player
    end
    
    def score
        return @score
    end
end