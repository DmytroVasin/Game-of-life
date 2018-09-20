# https://github.com/shanko/1010/blob/master/game_1010.rb
include Gosu

class GameWindow < Gosu::Window
  BORDER = 1
  CELL_SIZE = 30

  COLORS = {
    green:  Gosu::Color.new(*[248, 27, 184, 139]),
    white:  Gosu::Color::WHITE,
    gray:   Gosu::Color::GRAY
  }.freeze

  attr_accessor :game, :width, :height

  def initialize(game, options)
    @width = options.fetch(:width, 640)
    @height = options.fetch(:height, 640)

    super(@width, @height, { fullscreen: false })

    self.caption = "Tutorial Game"

    @game = game
    print_game

    @redraw = false
  end

  def update
    return unless redraw?

    p 'update!'
    game.generation_tick!
    print_game

    @redraw = false
  end

  def draw
    draw_fill
    draw_board
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE
      close
    when Gosu::KB_SPACE
      @redraw = true
    else
      super
    end
  end

  def needs_cursor?
    true
  end

  private

  def redraw?
    @redraw
  end

  def draw_fill
    draw_rect(0, 0, 0, @width, @height)
  end

  def draw_cell(x, y, is_fill)
    x_pos = BORDER + (x * (CELL_SIZE + BORDER))
    y_pos = BORDER + (y * (CELL_SIZE + BORDER))
    z = 1
    color = is_fill ? COLORS[:green] : COLORS[:gray]

    draw_sqr(x_pos, y_pos, z, CELL_SIZE, color)
  end

  def draw_sqr(x, y, z, width, color)
    draw_rect(x, y, z, width, width, color)
  end

  def draw_rect(x, y, z_order, width, height, color=COLORS[:white])
    Gosu.draw_quad(
      x,          y,          color,
      x + width,  y,          color,
      x,          y + height, color,
      x + width,  y + height, color,
      z_order
    )
  end

  def draw_board
    game.grid.matrix.flatten.each do |cell|
      draw_cell(cell.x, cell.y, cell.is_alive?)
    end
  end

  def print_game
    Printer.new(game).call
  end
end
