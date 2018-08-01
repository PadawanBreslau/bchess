module CastleHelpers
  def castle(piece, column, row)
    validate_castle(piece, column)
    update_castles_after_king_move(piece.color)
    execute_castle(piece, column, row)
  end

  def validate_castle(piece, column)
    !piece.moved && !rook_moved?(piece, column) && fen_allows?(piece,column)
  end

  def execute_castle(piece, column, row)
    piece.move(column, row)
    lngth = @short_castle ? 2 : 3
    @castling_rook = castling_rook(piece, column)
    @castling_rook.move((@castling_rook.column - lngth).abs, row)
  end

  def white_castle(column)
    if short_castle?(column)
      @short_castle = true
      at(7,0)
    else
      @short_castle = false
      at(0,0)
    end
  end

  def black_castle(column)
    if short_castle?(column)
      @short_castle = true
      at(7,7)
    else
      @short_castle = false
      at(0,7)
    end
  end

  def rook_moved?(piece, column)
    castling_rook(piece, column)&.moved
  end

  def castling_rook(piece, column)
    select_rook(piece, column)
  end

  def select_rook(piece, column)
    if piece.row == 0
      white_castle(column)
    elsif piece.row == 7
      black_castle(column)
    end
  end

  def short_castle?(column)
    column == 6
  end
end
