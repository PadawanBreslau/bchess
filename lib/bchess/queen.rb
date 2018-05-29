module Bchess
  class Queen < Piece

    def initiialize(*args)
      super(args)
    end

    def name
      'Q'
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        (
          by_line(dcolumn, drow, 7) ||
          by_diagonal(dcolumn, drow,  7)
      )
    end
  end
end
