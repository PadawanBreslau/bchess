require_relative 'bchess/helpers/board_helpers'
require_relative 'bchess/helpers/fen_helpers'
require_relative 'bchess/helpers/board_helpers'
require_relative 'bchess/helpers/castle_helpers'
require_relative 'bchess/helpers/validations'
require_relative 'bchess/helpers/en_passant_helpers'
require_relative 'bchess/helpers/field_between_helpers'

require_relative 'bchess/version'
require_relative 'bchess/piece'
require_relative 'bchess/king'
require_relative 'bchess/rook'
require_relative 'bchess/bishop'
require_relative 'bchess/queen'
require_relative 'bchess/knight'
require_relative 'bchess/pawn'
require_relative 'bchess/board'

require_relative 'pgn/parser'
require_relative 'pgn/pgn_file'
require_relative 'pgn/pgn_nodes'
require_relative 'pgn/game'
require_relative 'pgn/game_header'
require_relative 'pgn/game_body'
require_relative 'pgn/move_info_parser'

module Bchess
  class InvalidMoveException < StandardError; end

  WHITE = 'w'.freeze
  BLACK = 'b'.freeze
  START_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
end
