class ComputerPlayer

  def initialize
    @known_cards = Hash.new
    (0..3).each { |row| (0..3).each { |column| @known_cards[[row,column]] = "" } }
    
    @matched_cards = []
    @prev_guessed_pos = nil
  end

  def get_input
    chosen_position = nil
    puts "\n" + "*** Crumpbot is thinking..."

    counting_cards.each do |v, count|
      if count == 2
        if @prev_guessed_pos
          chosen_position = @known_cards.select { |pos, v2| v == v2 && @prev_guessed_pos != pos }.keys[0]
        else
          chosen_position = @known_cards.select { |pos, v2| v == v2 }.keys[0]
        end
      end
    end

    sleep(2)
    chosen_position = @known_cards.select { |pos, value| value == "" && !@matched_cards.include?(pos) }.keys.sample if !chosen_position
    @prev_guessed_pos ? @prev_guessed_pos = nil : @prev_guessed_pos = chosen_position
    chosen_position.join(",")
  end

  def counting_cards
    count = Hash.new(0)
    @known_cards.values.each { |value| count[value] += 1 if value != "" && !@matched_cards.include?(value)}
    count
  end

  def receive_revealed_card(pos, card_value)
    if @known_cards[pos] == ""
      puts "\n" + "I will remember that a card with the value of " + card_value + " exists at the following position: " + pos.to_s
      @known_cards[pos] = card_value
    else
      puts "\n" + "I already know a card with the value of " + card_value + " exists at the following position: " + pos.to_s
      puts "I am trying to create a match."
    end
    sleep(4)
  end

  def receive_match(match)
    @matched_cards.push(match)
  end
end