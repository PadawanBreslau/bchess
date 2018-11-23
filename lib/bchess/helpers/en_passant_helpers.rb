module EnPassantHelpers
  def validate_en_passant(_piece, _column, _row)
    # TODO
    true
  end

  def execute_en_passant(piece, row, column)
    piece.move(row, column)
    remove_old_piece(*remove_en_passant(piece, *transform_field(@en_passant)), piece.color)
  end

  def remove_en_passant(piece, column, row)
    direction = piece.color == Bchess::WHITE ? 1 : -1
    [column, row - direction]
  end

  def long_pawn_move(piece, column, row)
    piece.move(column, row)
    direction = piece.color == Bchess::WHITE ? 1 : -1
    @en_passant = field(column, (row + piece.row) / 2 - direction)
  end
end
