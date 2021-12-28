class Rank

    def initialize
        @scores = []
    end

    def scores
        return @scores
    end
    
    def add_score(player)
        @scores << Item.new(player)
    end

    def show_score()
        return @scores.sort_by {|item| item.score}.reverse
    end

end