class SlidingPuzzle
  def initialize(*tiles)
    self.tiles = flatten_tiles(tiles)
    self.max_row = @tiles.size - 1
    self.max_column = @tiles.first.size - 1
  end

  def slide!(direction)
    unless moves.include?(direction)
      raise InvalidMoveError, "unable to slide #{direction}"
    end

    x1, y1 = find(0)
    x2, y2 = x1, y1

    y2 += 1 if direction == :left
    y2 -= 1 if direction == :right
    x2 += 1 if direction == :up
    x2 -= 1 if direction == :down

    @tiles[x1][y1], @tiles[x2][y2] = @tiles[x2][y2], @tiles[x1][y1]
    self
  end

  def slide(direction)
    clone.slide!(direction)
  end

  def clone
    self.class.new(*tiles)
  end

  def print
    Kernel.print @tiles.map(&:inspect).join("\n")
  end

  def moves
    row, column = find(0)
    moves = []

    moves.push(:left) unless column == max_column
    moves.push(:right) unless column.zero?
    moves.push(:up) unless row == max_row
    moves.push(:down) unless row.zero?

    moves
  end

  def scramble!(moves: 100)
    moves.times do
      slide!(self.moves.sample)
    end

    self
  end

  def tiles
    JSON.parse(JSON.generate(@tiles))
  end

  def get(row, column)
    @tiles[row][column]
  end

  def find(number)
    tiles.each.with_index do |numbers, row|
      numbers.each.with_index do |n, column|
        return [row, column] if n == number
      end
    end

    nil
  end

  private

  def flatten_tiles(tiles)
    if tiles[0].is_a?(Array) && tiles[0][0].is_a?(Array)
      tiles.flatten(1)
    else
      tiles
    end
  end

  attr_accessor :max_row, :max_column
  attr_writer :tiles

  class InvalidMoveError < StandardError; end
end
