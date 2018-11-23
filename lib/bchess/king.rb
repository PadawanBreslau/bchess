module Bchess
  class King < Piece
    KINGS_REACH = 1

    attr_reader :moved

    def initiialize(*args)
      super(args)
      @moved = false
    end

    def name
      'K'
    end

    def move(dcolumn, drow)
      super(dcolumn, drow)
      @moved = true
    end

    def can_move_to_field?(dcolumn, drow)
      super &&
        (
          by_line(dcolumn, drow, KINGS_REACH) ||
          by_diagonal(dcolumn, drow, KINGS_REACH)
        )
    end
  end
end
