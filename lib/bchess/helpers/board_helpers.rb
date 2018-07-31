module Bchess
  module BoardHelpers
    def field(column, row)
      (column+97).chr + (row+1).to_s
    end

    def invalid_data?(piece, column, row)
      piece.nil? || !(0..7).include?(column) || !(0..7).include?(row)
    end

    def castle_detected?(piece, column)
      piece.kind_of?(Bchess::King) && piece.column == 4 && (column - piece.column).abs == 2
    end

    def promotion_detected?(piece, row)
      piece.kind_of?(Bchess::Pawn) && (row == 0 || row == 7)
    end

    def en_passant_detected?(piece, column, row)
      piece.kind_of?(Bchess::Pawn) && piece.row != row && piece.column != column && at(column, row).nil? && piece.can_take_on_field?(column, row)
    end

    def pawn_long_move_detected?(piece, row)
      piece.kind_of?(Bchess::Pawn) && (piece.row - row).abs == 2
    end

    def kings_present?
      !!king(Bchess::WHITE) && !!king(Bchess::BLACK)
    end

    def to_row(row)
      row.to_i - 1
    end

    def to_column(column)
      column.bytes.first - 97
    end

    def field(column, row)
      (column+97).chr + (row+1).to_s
    end
  end
end
