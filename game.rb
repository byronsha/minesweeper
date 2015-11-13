require_relative "board"

class Game
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def play
    until won?
      if game_over?
        print "GAMEOVER!"
        return
      end
      play_step
    end
    @board.display
    print "\nYOU WIN!\n\n"
  end

  def play_step
    @board.display
    puts "\nOpen(O), Flag(F), or Unflag(F)?"
    action = gets.chomp.downcase
    puts "Which tile?"
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
    @board.board.flatten.select { |tile| tile.showing && tile.value == :b }.count >= 1
  end

  def won?
    @board.board.flatten.select { |tile| tile.showing == false }.count == @board.num_bomb
  end
end


b = Board.new(9, 5)
g = Game.new(b)
g.play
