require_relative "card.rb"

class Board
    def initialize
        @cards = [*"A".."H",*"A".."H"].map { |char| Card.new(char) }
        @grid = populate(@cards.shuffle)
    end

    def populate(cards)
        cards.each_slice(4).to_a
    end

    def render
        puts "\e[H\e[2J"
        puts "  0 1 2 3"
        @grid.map.with_index { |line, i| puts i.to_s + " " + line.map(&:check_value).join(" ") }
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

    def []=(pos, val)
    end
end