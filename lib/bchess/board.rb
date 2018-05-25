module Bchess
  class Board
    attr_reader :fen, :pieces, :color_to_move, :castles, :en_passant, :halfmove_clock, :move_number

    def initialize(fen)
      @fen = fen
      @pieces = []
      read_fen
    end

    def valid_board?

    end

    def read_fen
      board, @color_to_move, @castles, @en_passant, @halfmove_clock, @move_number = fen.strip.split(" ")
      puts board
    end

    def create_position

    end

    def execute(move)

    end
  end
end
