module Bchess
  class Rook < Piece

    def initiialize(*args)
      super(args)
    end

    def name
      'R'
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        by_line(dcolumn, drow, 7)
    end
  end
end
