require_relative "board"

class Game
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def play
    until won?
      if game_over?
        @board.display
        print "\n\nGAMEOVER!\n\n"
        return
      end
      play_step
    end
    @board.board.flatten.select { |tile| tile.showing == false }.each do |tile|
      tile.flag
    end
    @board.display
    print "\n\nYOU WIN!\n\n"
  end

  def play_step
    @board.display
    puts "\n\nOpen(O), Flag(F), or Unflag(F)?"
    action = gets.chomp.downcase
    puts "\nWhich tile?"
    tile = gets.chomp.delete(" ").split(",").map(&:to_i)
    x, y = tile
    if action == "o"
      @board.board[x][y].reveal
      @board.reveal_chain(tile)
    elsif action == "f"
      @board.board[x][y].flag
    elsif action == "u"
      @board.board[x][y].unflag
    end
  end

  def game_over?
    @board.board.flatten.select { |tile| tile.showing && tile.value == "💣" }.count >= 1
  end

  def won?
    return if game_over?
    @board.board.flatten.select { |tile| tile.showing == false }.count == @board.num_bomb
  end
end


if __FILE__ == $PROGRAM_NAME
  # system ("clear")
  # puts "Enter board size:"
  # size = gets.chomp.to_i
  # puts "Enter mine count:"
  # mine_count = gets.chomp.to_i
  # board = Board.new(size, mine_count)
  board = Board.new(9, 5)
  game = Game.new(board)
  game.play
end
