module Bchess
  class Rook < Piece
    ROOK_REACH = 7

    attr_accessor :moved

    def initiialize(*args)
      super(args)
      @moved = false
    end

    def name
      'R'
    end

    def move(dcolumn, drow)
      super(dcolumn, drow)
      @moved = true
    end

    def can_move_to_field?(dcolumn, drow)
      super && by_line(dcolumn, drow, ROOK_REACH)
    end
  end
end
