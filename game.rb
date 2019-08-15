require_relative "board.rb"
require_relative "card.rb"
require_relative "player.rb"

class Game
    def initialize
        @board = Board.new
        @player = Player.new
        @prev_guessed_pos = nil

        play
    end

    def play
        until @board.win?
            @board.render

            puts ""
            puts "Enter a position (e.g., 1,2)"
            pos = @player.pick_a_position(gets.chomp)

            while @board[pos].face_up
                puts ""
                puts "This card is already face up"
                pos = @player.pick_a_position(gets.chomp)
            end

            @board.reveal(pos)

            @board.render

            @prev_guessed_pos ? compare_cards(pos) : @prev_guessed_pos = @board[pos]
        end

        game_over
    end

    def compare_cards(pos)
        if @board[pos] == @prev_guessed_pos
            puts ""
            puts "You got a match!"

            sleep(2)

            @prev_guessed_pos = nil
        else
            puts ""
            puts "That's not a match!"
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
