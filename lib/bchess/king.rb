module Bchess
  class King < Piece

    def initiialize(*args)
      super(args)
    end

    def name
      'K'
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        (
          by_line(dcolumn, drow, 1) ||
          by_diagonal(dcolumn, drow, 1)
      )
    end
  end
end
