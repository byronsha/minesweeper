require "colorize"
require_relative "tile.rb"
require_relative "cursorable"

class Board
  include Cursorable

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
    until @board.flatten.count{|el| el.value == "💣"} == @num_bomb
      x = rand(size)
      y = rand(size)

      @board[x][y].value = "💣" if @board[x][y].value != "💣"
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
    unless @board[pos[0]][pos[1]].value == "💣"
      bomb_count = 0
      surrounding = surrounding_tiles(pos)
      surrounding.each do |tile|
        bomb_count += 1 if @board[tile[0]][tile[1]].value == "💣"
      end
      color = assign_color(bomb_count)
      @board[pos[0]][pos[1]].value = bomb_count.to_s.colorize(color) if bomb_count != 0
    end
  end

  def assign_color(num)
    case num
    when 1
      {color: :blue}
    when 2
      {color: :green}
    when 3
      {color: :red}
    when 4
      {color: :magenta}
    else
      {color: :white}
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

    unless @board[pos[0]][pos[1]].value == "."
      @board[pos[0]][pos[1]].reveal
      return
    end

    until reveal_queue.empty?
      x, y = reveal_queue.first
      @board[x][y].reveal
      checked_tiles << [x,y]

      surrounding = surrounding_tiles([x,y])

      surrounding.each do |pos|
        @board[pos[0]][pos[1]].reveal unless @board[pos[0]][pos[1]].value == "💣"
      end

      surrounding = surrounding.select {|el| @board[el[0]][el[1]].value == "."}
      surrounding = surrounding.select {|el| !checked_tiles.include?(el)}

      reveal_queue += surrounding
      reveal_queue.shift
    end
  end

  def display
    system ("clear")
    print "    "
    (0...@size).each do |num|
      print "#{num} "
    end
    print "\n"
    @board.each_with_index do |row, idx|
      print "\n#{idx}   "
      row.each do |el|
        if el.showing && el.value != "💣"
          print "#{el.value} ".colorize({background: :light_black})
        elsif el.showing && el.value == "💣"
          print "#{el.value} ".colorize({background: :red})
        elsif el.flagged
          print "🚩 "
        else
          print "⬜ "
        end
      end
    end
  end
end
