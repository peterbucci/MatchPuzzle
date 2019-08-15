class Player
  def initialize
  end

  def pick_a_position(user_input)
    if valid_move?(user_input)
        user_input.split(",").map(&:to_i)
    else
        puts ""
        puts "Please enter a *valid* position (e.g., 1,2)"
        pick_a_position(gets.chomp)
    end
  end

  def valid_move?(user_input)
    /[0-3],[0-3]$/.match?(user_input) ? true : false
  end

end