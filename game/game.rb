class Cell
  attr_accessor :x, :y, :alive, :next_state

  def initialize(x, y, is_alive = nil)
    @alive  = if is_alive.nil?
                [true, false].sample
              else
                is_alive
              end

    @x = x
    @y = y
    @next_state = false
  end

  def is_alive?
    alive
  end

  def is_dead?
    !self.is_alive?
  end

  def should_die!
    @next_state = false
  end

  def should_live!
    @next_state = true
  end

  def switch!
    @alive = @next_state
  end
end

class Grid
  attr_accessor :matrix

  def initialize(size)
    @matrix = build_matrix(size)
  end

  def siblings_for(cell)
    alive_cells = 0

    north_west,  north, north_east,
       west,       _,      east,
    south_west,  south, south_east =

    [
      [-1, -1], [0, -1],  [1, -1],
      [-1,  0],   [:x],   [1,  0],
      [-1,  1], [0,  1],  [1,  1],
    ]

    [
      north_west, north,  north_east,
      west,               east,
      south_west,  south, south_east
    ].each do |direction| # TODO: reduce!
      x_position = cell.x + direction[0]
      y_position = cell.y + direction[1]

      next if x_position.negative? || y_position.negative?
      next if x_position >= matrix.size || y_position >= matrix.size

      sibling = matrix.dig(y_position, x_position)

      next if sibling.is_dead?

      alive_cells += 1
    end

    alive_cells
  end

  private

  def build_matrix(size)
    Matrix.build(size) do |row, col|
      Cell.new(col, row)
    end.to_a
  end
end

class Game
  attr_accessor :grid

  def initialize(size=3)
    @grid = Grid.new(size)
  end

  def generation_tick!
    all_cells = grid.matrix.flatten

    all_cells.each do |cell|
      alive_siblings_count = grid.siblings_for(cell)

      # First rule: => Underpopulation
      if cell.is_alive? && alive_siblings_count < 2
        cell.should_die!
      end

      # Second rule: => Continue living
      if cell.is_alive? && alive_siblings_count.between?(2, 3)
        cell.should_live!
      end

      # Third rule: => Overcrowding
      if cell.is_alive? && alive_siblings_count > 3
        cell.should_die!
      end

      # Fourth rule: => Reproduction
      if cell.is_dead? && alive_siblings_count == 3
        cell.should_live!
      end
    end

    all_cells.each do |cell|
      cell.switch!
    end
  end

  def apply_grid(new_grid)
    size = new_grid.size

    grid.matrix = Matrix.build(size) do |row, col|
      cell = Cell.new(col, row)
      cell.alive = !new_grid[row][col].zero?
      cell
    end.to_a

    self
  end
end
