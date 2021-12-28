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

private def add_question(question)
    @questions << question
end

private def load_questions_text_file(path_relative)
    text_file = File.new(path_relative, "r")
    text_file.each do |line| 
        question_array = line.split(",")
        question = Question.new(question_array[0], question_array.select.with_index { |value, index| index > 0})
        question.alternatives[0].is_correct = true
        question.shuffle_alternatives()
        add_question(question)
    end
    text_file.close
end

private def print_dashed_line()
    60.times do
        print "_"
    end
    puts
end

private def enter_to_continue()
    puts
    print "Tecle enter para continuar..."
    return gets.chomp    
end

private def select_item()
    puts
    print "Escolha uma das opções (digite o número e tecle enter): "
    return gets.to_i
end

private def print_right_answer()
    puts
    puts "Certa a resposta!"
    print_dashed_line()
end

private def print_wrong_answer()
    puts
    puts "Você errou!"
    print_dashed_line()
end

private def print_invalid_answer()
    puts
    puts "Resposta inválida! "
    print_dashed_line()
end

private def print_score()
    puts "".chomp
    puts "#{@current_player.name} acertou #{@current_player.score} e errou #{@current_player.questions.length - @current_player.score} questão(ões)"
    print_dashed_line()
end

private def print_rank()
    clear_screen()
    puts "Classificação Geral"
    print_dashed_line()
    puts
    puts "Posição - Jogador - Pontuação"
    print_dashed_line()
    puts "".chomp
    @rank.show_score.each_with_index do |item, index|
        puts "%d - %s - %d" % [index + 1, item.name_player, item.score]
        print_dashed_line()
    end
    enter_to_continue()
end

private def clear_screen
    system('cls')
end

private def print_menu()
    clear_screen()    
    puts "1) Novo Jogo"
    puts "2) Ver placar"
    puts "3) Sair"
end  

private def play_again()
    puts
    puts "Deseja jogar novamente? (s/n)" 
    case gets.to_s.chomp
    when "s", "S"
        return true
    when "n", "N"
        return false
    else
        print_invalid_answer()
        return play_again()
    end
end

private def create_player_by_keyboard()
    clear_screen()
    print "Digite seu nome: "
    name = gets.to_s.chomp
    clear_screen()
    return Player.new(name)
end

private def add_player(player)
    @players << player
end

private def randomize_questions()
    return @questions.sample(NUMBER_QUESTIONS_FOR_GAME)
end

private def add_random_questions_for_player()
    @current_player.questions = randomize_questions()
end

private def new_game()
    if(@current_player == nil)
        @current_player = create_player_by_keyboard()
        add_player(@current_player)
    end
    @current_player.reset_score()
    add_random_questions_for_player()
    clear_screen()    
    @current_player.questions.each_with_index do |value, index|
        print_question(index + 1, value)
        verify_alternative_selected(select_alternative(value))
        enter_to_continue()
        clear_screen()
    end
    @rank.add_score(@current_player)
    print_score()
    self.play_again() ? new_game() : @current_player = nil
end

private def print_welcome()
    clear_screen()
    puts "Bem-vindo ao jogo de perguntas e respostas!" 
    print_dashed_line()
    puts
    enter_to_continue()
end

private def print_question(order, question)
    puts "#{order}) #{question.question}\n\n"
    question.alternatives.each_with_index {|line, index| puts "#{index + 1}- #{line.text}"} 
end 

private def verify_alternative_selected(alternative)
    if(alternative.is_correct)
        @current_player.increment_score()
        print_right_answer()
    else
        print_wrong_answer()
    end
end

private def select_alternative(question)
    item = select_item()
    case item
    when 1,2,3,4
        return question.get_alternative(item-1)
    else
        print_invalid_answer()
        select_alternative(question)    
    end    
end

load_questions_text_file("questions.txt")
print_welcome()

loop do 
    print_menu()
    case select_item()
        when 1
            new_game()
        when 2
            print_rank()
        when 3
            break
    end
end