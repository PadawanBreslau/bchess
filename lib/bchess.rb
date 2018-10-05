require "bchess/helpers/board_helpers"
require "bchess/helpers/fen_helpers"
require "bchess/helpers/board_helpers"
require "bchess/helpers/castle_helpers"
require "bchess/helpers/validations"
require "bchess/helpers/en_passant_helpers"
require "bchess/helpers/field_between_helpers"

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
require "pgn/pgn_file"
require "pgn/game"
require "pgn/game_header"
require "pgn/game_body"
require "pgn/move_info_parser"

module Bchess
  class InvalidMoveException < StandardError; end

  WHITE = 'w'
  BLACK = 'b'
  START_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
end
