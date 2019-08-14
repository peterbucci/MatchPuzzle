class Card
    attr_reader :face_up

    def initialize(face_value)
        @face_value = face_value
        @face_up = false
    end

    def check_value
        return @face_value if @face_up
        " "
    end

    def reveal
        @face_up = true
    end

    def hide
        @face_up = false
    end

    def to_s
    end

    def ==(another_card)
        check_value == another_card.check_value
    end
end