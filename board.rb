require_relative "card.rb"

class Board
    def initialize(difficulty)
        half_the_deck = [*"A".."Z"].slice(0...difficulty * (difficulty / 2.0))
        @cards = [*half_the_deck,*half_the_deck].map { |char| Card.new(char) }
        @grid = populate(difficulty)
    end

    def populate(difficulty)
        @cards.shuffle.each_slice(difficulty).to_a
    end

    def render(tries_left)
        puts "\e[H\e[2J"
        puts "  " + @grid.map.with_index { |_, i| i }.join(" ")
        @grid.map.with_index { |line, i| puts i.to_s + " " + line.map(&:check_value).join(" ") }
        puts "\n" + "Tries Left: " + tries_left.to_s + "\n"
    end

    def win?
        @cards.all? { |card| card.face_up }
    end

    def reveal(pos)
        chosen_card = self[pos]
        chosen_card.reveal
    end

    def [](pos)
        row = pos[0]
        column = pos[1]
        @grid[row][column]
    end
end