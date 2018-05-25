module Bchess
  class Game
    attr_reader :fen, :board, :moves

    def initialize(fen='')
      @fen = fen
      @board = Board.new(fen)
      @moves = []
    end

    def add_move(move)
      moves << move
    end

    def validate_game
      moves.all? do |move|
        board.execute(move)
      end
    end
  end
end
