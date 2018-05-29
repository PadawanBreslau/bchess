module Bchess
  class King < Piece

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
          by_line(dcolumn, drow, 1) ||
          by_diagonal(dcolumn, drow, 1)
      )
    end
  end
end
