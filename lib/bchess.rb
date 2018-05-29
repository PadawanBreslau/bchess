require "bchess/version"
require "bchess/piece"
require "bchess/king"
require "bchess/rook"
require "bchess/bishop"
require "bchess/queen"
require "bchess/knight"
require "bchess/pawn"
require "bchess/board"
require "pgn/parser"


module Bchess
  WHITE = 'w'
  BLACK = 'b'
  START_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
end
