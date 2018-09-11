module Bchess
  class Queen < Piece
    QUEEN_REACH = 7

    def initiialize(*args)
      super(args)
    end

    def name
      'Q'
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        (
          by_line(dcolumn, drow, QUEEN_REACH) ||
          by_diagonal(dcolumn, drow,  QUEEN_REACH)
      )
    end
  end
end
