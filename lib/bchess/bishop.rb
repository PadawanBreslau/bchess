module Bchess
  class Bishop < Piece
    BISHOP_REACH = 7

    def initiialize(*args)
      super(args)
    end

    def name
      'B'
    end

    def can_move_to_field?(dcolumn, drow)
      super && by_diagonal(dcolumn, drow, BISHOP_REACH)
    end
  end
end
