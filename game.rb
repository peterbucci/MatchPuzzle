require_relative "board.rb"
require_relative "card.rb"

class Game
    def initialize
        @board = Board.new
        @prev_guessed_pos = nil

        play
    end

    def play
        until @board.win?
            @board.render

            pos = pick_a_position
            @board.reveal(pos)

            @prev_guessed_pos ? compare_cards(pos) : @prev_guessed_pos = @board[pos]
        end

        game_over
    end

    def pick_a_position
        puts ""
        puts "Enter a position (e.g., 1,2)"
        pos = valid_move?(gets.chomp)
        while @board[pos].face_up
            puts "This card is already face up"
            pos = valid_move?(gets.chomp)
        end

        pos
    end

    def valid_move?(user_input)
        return user_input.split(",").map(&:to_i) if /[0-3],[0-3]/.match?(user_input)
            
        puts ""
        puts "Please enter a *valid* position (e.g., 1,2)"
        valid_move?(gets.chomp)
    end

    def compare_cards(pos)
        if @board[pos] == @prev_guessed_pos
            @prev_guessed_pos = nil
        else
            @board.render
            puts ""
            puts "Not a match!"
            puts "Try again"
            sleep(2)
            @board[pos].hide
            @prev_guessed_pos.hide
            @prev_guessed_pos = nil
        end
    end

    def game_over
        @board.render
        puts ""
        puts "You win!"
    end
end

Game.new
