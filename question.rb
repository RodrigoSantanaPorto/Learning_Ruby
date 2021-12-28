class Question 

    attr_accessor :question
    attr_reader :alternatives

    def initialize(text, alternatives=[]) 
        @alternatives = []
        @question = text
        self.add_alternatives(alternatives)
    end    
    
    def add_alternative(text)
        @alternatives << Alternative.new(text)
    end

    def add_alternatives(text_array=[])
        text_array.each { |text| self.add_alternative(text) }
    end

    def get_alternative(index)
        return @alternatives[index]
    end

    def shuffle_alternatives()
        @alternatives = @alternatives.shuffle()
    end

end