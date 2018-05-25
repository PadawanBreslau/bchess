module Bchess
  class Pawn < Piece

    def initiialize(*args)
      super(args)
    end

    def valid?
      super && pawn_position?
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        pawn_move(dcolumn, drow)
    end

    def can_take_on_field?(dcolumn, drow)
      direction = white? ? 1 : -1
      by_diagonal(drow, dcolumn, 1) && (drow - row) == direction
    end

    def fields_between
      []
    end

    private

    def pawn_move(dcolumn, drow)
      row_diff?(dcolumn, drow) &&
        direction_kept?(dcolumn, drow) &&
        column == dcolumn
    end

    def direction_kept?(dcolumn, drow)
      white? ? drow > row : row > drow
    end

    def row_diff?(dcolumn, drow)
      (row - drow).abs <= (starting_position? ? 2 : 1)
    end

    def starting_position?
      row == (white? ? 1 : 6)
    end

    def pawn_position?
      (1..6).include?(row)
    end
  end
end
