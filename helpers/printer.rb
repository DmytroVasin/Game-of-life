require 'terminal-table'

class Printer
  attr_accessor :game

  def initialize(game)
    @game = game
  end

  def call
    rows = []

    game.grid.matrix.each do |row|
      terminal_row = row.map do |val|
        val.is_alive? ? "1 (#{val.x}:#{val.y})" : "0 (#{val.x}:#{val.y})"
      end

      rows.push(terminal_row)
    end

    puts Terminal::Table.new(rows: rows)
  end
end
