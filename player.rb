class Player
  def initialize
  end

  def get_input(message = "Enter a position (e.g., 1,2)")
    puts ""
    puts message
    gets.chomp
  end
end