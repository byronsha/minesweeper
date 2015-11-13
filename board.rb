require_relative "tile.rb"

class Board

  ADJACENT = [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]]

  attr_accessor :board, :size, :num_bomb

  def initialize(size, num_bomb)
    @size = size
    @board = Array.new(size){Array.new(size)}
    @board.map! do |row|
      row.map! do |el|
        el = Tile.new
      end
    end
    @num_bomb = num_bomb
    populate_bombs
    populate_all_nums
  end

  def populate_bombs
    until @board.flatten.count{|el| el.value == :b} == @num_bomb
      x = rand(size)
      y = rand(size)

      #@board[x][y] = :b if @board[x][y] != :b
      @board[x][y].value = :b if @board[x][y].value != :b
    end
  end

  def populate_all_nums
    (0...size).each do |i|
      (0...size).each do |j|
        populate_num([i,j])
      end
    end

  end

  def populate_num(pos)
    unless @board[pos[0]][pos[1]].value == :b
      bomb_count = 0
      surrounding = surrounding_tiles(pos)
      surrounding.each do |tile|
        bomb_count += 1 if @board[tile[0]][tile[1]].value == :b
        #p bomb_count
      end
      @board[pos[0]][pos[1]].value = bomb_count if bomb_count != 0
    end
  end

  def surrounding_tiles(pos)
    tiles = []

    ADJACENT.each do |i|
      x, y = i
      pos_x, pos_y = pos
      tiles << [pos_x + x, pos_y + y] if (pos_x + x) < size && (pos_y + y) < size && (pos_x + x) >= 0 && (pos_y + y) >= 0
    end
    tiles
  end

  def reveal_chain(pos)

    reveal_queue = [pos]
    checked_tiles = []

    unless @board[pos[0]][pos[1]].value == "-"
      @board[pos[0]][pos[1]].reveal
      return
    end

    until reveal_queue.empty?
      x, y = reveal_queue.first
      @board[x][y].reveal
      checked_tiles << [x,y]

      surrounding = surrounding_tiles([x,y])

      surrounding.each do |pos|
        @board[pos[0]][pos[1]].reveal unless @board[pos[0]][pos[1]].value == :b
      end

      surrounding = surrounding.select {|el| @board[el[0]][el[1]].value == "-"}
      surrounding = surrounding.select {|el| !checked_tiles.include?(el)}

      reveal_queue += surrounding
      reveal_queue.shift
    end

  end

  def display
    print "    0 1 2 3 4 5 6 7 8\n"
    @board.each_with_index do |row, idx|
      print "\n#{idx}   "
      row.each do |el|
        if el.showing
          print "#{el.value} "
        elsif el.flagged
          print "F "
        else
          print "* "
        end
      end
    end
  end

end
