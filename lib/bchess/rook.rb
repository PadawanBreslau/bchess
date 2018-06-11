module Bchess
  class Rook < Piece

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
      super &&
        by_line(dcolumn, drow, 7)
    end
  end
end
