require_relative 'player'
require_relative 'question'
require_relative 'alternative'
require_relative 'item'
require_relative 'rank'

NUMBER_QUESTIONS_FOR_GAME = 3

@current_player = nil
@players = []
@questions = []
@rank = Rank.new()

def add_question(question)
    @questions << question
end

def load_questions_text_file(path_relative)
    text_file = File.new(path_relative, "r")
    text_file.each do |line| 
        question_array = line.split(",")
        question = Question.new(question_array[0], question_array.last(4))
        question.alternatives[0].is_correct = true
        question.shuffle_alternatives()
        add_question(question)
    end
    text_file.close
end

def print_dashed_line()
    60.times do
        print "_"
    end
    puts
end

def print_message(text)
    puts
    puts text
end

def print_message_with_dashed_line(text)
    print_message(text)
    print_dashed_line    
end

def enter_to_continue
    print_message("Tecle enter para continuar...")
    return gets.chomp    
end

def select_item
    print_message("Escolha uma das opções (digite o número e tecle enter): ")
    return gets.to_i
end

def print_right_answer
    print_message_with_dashed_line("Certa a resposta!")
end

def print_wrong_answer
    print_message_with_dashed_line("Você errou!")
end

def print_invalid_answer
    print_message_with_dashed_line("Resposta inválida!")
end

def print_score
    print_message_with_dashed_line("#{@current_player.name} acertou #{@current_player.score} e errou #{@current_player.questions.length - @current_player.score} questão(ões)")
end

def print_rank
    clear_screen
    print_message_with_dashed_line("Classificação Geral")
    print_message_with_dashed_line("Posição - Jogador - Pontuação")
    @rank.show_score.each_with_index do |item, index|
        print_message_with_dashed_line("%d - %s - %d" % [index + 1, item.name_player, item.score])
    end
    enter_to_continue
end

def clear_screen
    system('cls')
end

def print_menu
    clear_screen    
    puts "1) Novo Jogo"
    puts "2) Ver placar"
    puts "3) Sair"
end  

def play_again
    print_message("Deseja jogar novamente? (s/n)")
    case gets.to_s.chomp
    when "s", "S"
        return true
    when "n", "N"
        return false
    else
        print_invalid_answer
        return play_again
    end
end

def create_player_by_keyboard
    clear_screen
    print "Digite seu nome: "
    name = gets.to_s.chomp
    clear_screen
    return Player.new(name)
end

def add_player(player)
    @players << player
end

def randomize_questions
    return @questions.sample(NUMBER_QUESTIONS_FOR_GAME)
end

def add_random_questions_for_player
    @current_player.questions = randomize_questions
end

def new_game
    if(@current_player == nil)
        @current_player = create_player_by_keyboard
        add_player(@current_player)
    end
    @current_player.reset_score
    add_random_questions_for_player
    clear_screen    
    @current_player.questions.each_with_index do |value, index|
        print_question(index + 1, value)
        verify_alternative_selected(select_alternative(value))
        enter_to_continue
        clear_screen
    end
    @rank.add_score(@current_player)
    print_score
    self.play_again ? new_game : @current_player = nil
end

def print_welcome
    clear_screen
    print_message_with_dashed_line("Bem-vindo ao jogo de perguntas e respostas!" )
    enter_to_continue
end

def print_question(order, question)
    puts "#{order}) #{question.question}\n\n"
    question.alternatives.each_with_index {|line, index| puts "#{index + 1}- #{line.text}"} 
end 

def verify_alternative_selected(alternative)
    if(alternative.is_correct)
        @current_player.increment_score
        print_right_answer
    else
        print_wrong_answer
    end
end

def select_alternative(question)
    item = select_item
    case item
    when 1,2,3,4
        return question.get_alternative(item-1)
    else
        print_invalid_answer
        select_alternative(question)    
    end    
end

load_questions_text_file("questions.txt")
print_welcome

loop do 
    print_menu
    case select_item
        when 1
            new_game
        when 2
            print_rank
        when 3
            break
    end
end