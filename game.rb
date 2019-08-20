require_relative "board.rb"
require_relative "card.rb"
require_relative "player.rb"
require_relative "ComputerPlayer.rb"

class Game
    def initialize(player_type, difficulty)
        @board = Board.new(difficulty)
        @player = player_type
        @prev_guessed_pos = nil
        @difficulty = difficulty
        @tries = difficulty

        play
    end

    def play
        until @board.win? || @tries == 0
            @board.render(@tries)

            valid_move?(@player.get_input)

            @board.reveal(@pos)
            @board.render(@tries)

            @player.receive_revealed_card(@pos, @board[@pos].check_value) if @player.kind_of?(ComputerPlayer)
            @prev_guessed_pos ? compare_cards : @prev_guessed_pos = @board[@pos]
        end

        game_over
    end

    def valid_move?(user_input)
        pattern = "[0-#{@difficulty-1}]"

        if /^#{pattern},#{pattern}$/.match?(user_input) 
            @pos = user_input.split(",").map(&:to_i)
            return @pos if !@board[@pos].face_up
                
            user_input = @player.get_input("This card is already face up!")
        else
            user_input = @player.get_input("Please enter a *valid* position (e.g., 1,2)")
        end

        valid_move?(user_input)
    end

    def compare_cards
        matched = @board[@pos] == @prev_guessed_pos

        if matched
            puts "\n" + "You got a match!"
            @player.receive_match(@board[@pos].check_value) if @player.kind_of?(ComputerPlayer)
        else
            puts "\n" + "That's not a match!"
            puts "Try again!"
            @tries -= 1
        end

        sleep(2)

        hide_guesses if !matched
        @prev_guessed_pos = nil
    end

    def hide_guesses
        @board[@pos].hide
        @prev_guessed_pos.hide
    end

    def game_over
        @board.render(@tries)

        puts "\n" + "You win!" if @board.win?
        puts "\n" + "Sorry, you Lose!"
    end
end

def get_player_type(message = "Would you like to watch Crumpbot play?")
    puts message
    user_input = gets.chomp.downcase

    return ComputerPlayer.new if user_input == "yes"
    return Player.new if user_input == "no"

    get_player_type("Please enter yes or no.")
end

def get_difficulty(message = "Please enter a difficulty? e.g. easy, medium, hard, or very hard")
    puts message
    user_input = gets.chomp.downcase

    return 4 if user_input == "easy"
    return 5 if user_input == "medium"
    return 6 if user_input == "hard"
    return 7 if user_input == "very hard"

    get_difficulty("Please enter a valid difficulty! e.g. easy, medium, hard, or very hard")
end

Game.new(get_player_type, get_difficulty)
