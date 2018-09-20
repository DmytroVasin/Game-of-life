require 'gosu'
require 'pry'
require 'matrix'

require './helpers/printer'

require './game/game'
require './game/game_window'

matrix_size = 20
game = Game.new(matrix_size)
GameWindow.new(game, { width: 640, height: 640 }).show
