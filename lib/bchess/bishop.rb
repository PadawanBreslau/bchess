module Bchess
  class Bishop < Piece

    def initiialize(*args)
      super(args)
    end

    def name
      'B'
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        by_diagonal(dcolumn, drow, 7)
    end
  end
end
