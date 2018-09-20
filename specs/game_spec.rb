require 'matrix'
require 'rspec'
require 'awesome_print'
require 'pry'

require './helpers/printer'

require './game/game'

describe 'Game' do
  let(:dead) { false }
  let(:live) { true }

  context 'case 1' do
    let(:grid_1) {[
      [0, 1, 0],
      [0, 1, 0],
      [0, 1, 0],
    ]}

    let(:grid_2) {[
      [0, 0, 0],
      [1, 1, 1],
      [0, 0, 0],
    ]}

    let(:game){ Game.new.apply_grid(grid_1) }

    it 'should become grid_2' do
      game.generation_tick!

      expect(gridify(game)).to match_array(grid_2)
    end
  end

  def gridify(game)
    Printer.new( game ).call

    game.grid.matrix.map{ |x| x.map{ |y|
      y.is_alive? ? 1 : 0
    }}
  end
end
