require_relative "board.rb"
require_relative "card.rb"
require_relative "player.rb"
require_relative "ComputerPlayer.rb"

class Game
    def initialize
        @board = Board.new
        @player = ComputerPlayer.new
        @prev_guessed_pos = nil

        play
    end

    def play
        until @board.win?
            @board.render

            valid_move?(@player.get_input)

            @board.reveal(@pos)
            @board.render

            @player.receive_revealed_card(@pos, @board[@pos].check_value)
            @prev_guessed_pos ? compare_cards : @prev_guessed_pos = @board[@pos]
        end

        game_over
    end

    def valid_move?(user_input)
        if /[0-3],[0-3]$/.match?(user_input) 
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
            @player.receive_match(@board[@pos].check_value)
        else
            puts "\n" + "That's not a match!"
            puts "Try again!"
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
        @board.render

        puts "\n" + "You win!"
    end
end

Game.new
