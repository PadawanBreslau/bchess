module Bchess
  class Board
    attr_reader :fen, :to_move, :pieces, :color_to_move, :castles, :en_passant, :halfmove_clock, :move_number

    def initialize(fen = Bchess::START_FEN, to_move = Bchess::WHITE)
      @fen = fen
      @to_move = to_move
      @pieces = []
    end

    def move(piece, column, row)
      return false if piece.nil? || !(0..7).include?(column) || !(0..7).include?(row)

      if piece.can_move_to_field?(column,row)
        old_column, old_row = piece.column, piece.row
        piece.move(column,row)
        change_to_move

        if !valid_position?
          piece.move(old_column, old_row)
          change_to_move
          false
        else
          remove_old_piece(column,row, piece.color)
          true
        end
      else
        false
      end
    end

    def valid_position?
      kings_present? &&
        !king_attacked(just_moved)
    end

    def print
      puts 'Pieces WHITE: '
      puts _pieces(Bchess::WHITE).map{|p| p.to_s }.join(', ')
      puts 'Pieces BLACK: '
      puts _pieces(Bchess::BLACK).map{|p| p.to_s }.join(', ')
    end

    private

    def read_fen
      board, @color_to_move, @castles, @en_passant, @halfmove_clock, @move_number = fen.strip.split(" ")
    end

    def remove_old_piece(column, row, color)
      taken_piece = _other_pieces(color).select{|p| p.row == row && p.column == column}.first
      pieces.delete(taken_piece)
    end

    def change_to_move
      @to_move = to_move == Bchess::WHITE ? Bchess::BLACK : Bchess::WHITE
    end

    def just_moved
      to_move == Bchess::WHITE ? Bchess::BLACK : Bchess::WHITE
    end

    def kings_present?
      !!king(Bchess::WHITE) && !!king(Bchess::BLACK)
    end

    def king(color)
      @pieces.select{ |p| p.class == Bchess::King && p.color == color }.first
    end

    def king_attacked(color)
      _king = king(color)
      _pieces = _other_pieces(color)

      _pieces.any?{|p| attacks?(p, _king)}
    end

    def attacks?(piece, king)
      piece.can_take_on_field?(king.column, king.row) &&
        piece.fields_between(king.column, king.row).none?{|c,r| pieces.any?{|p| p.at?(c,r) }}
    end


    def _pieces(color)
      @pieces.select{ |p| p.color == color }
    end

    def _other_pieces(color)
      @pieces.select{ |p| p.color != color }
    end
  end
end
