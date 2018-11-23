module Bchess
  class Knight < Piece
    def initiialize(*args)
      super(args)
    end

    def name
      'N'
    end

    def can_move_to_field?(dcolumn, drow)
      super && by_jump(dcolumn, drow)
    end

    def fields_between(_column, _row)
      []
    end

    private

    def by_jump(dcolumn, drow)
      (row - drow).abs + (column - dcolumn).abs == 3 &&
        (row - drow).abs != 3 && (column - dcolumn).abs != 3
    end
  end
end
