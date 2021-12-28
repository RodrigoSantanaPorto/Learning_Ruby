class Alternative

    attr_accessor :text, :is_correct

    def initialize(text, iscorrect=false) 
        @text = text
        @is_correct = iscorrect
    end    
    
end