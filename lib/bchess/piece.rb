module Bchess
  class Piece
    attr_reader :color, :column, :row

    def initialize(color, column, row)
      @color = color
      @column = column
      @row = row
    end

    def to_s
      name + field(column, row)
    end

    def name
      raise Exception.new("Should be defined in subclass")
    end

    def field(column, row)
      (column+97).chr + (row+1).to_s
    end

    def at?(dcolumn, drow)
      column == dcolumn && row == drow
    end

    def move(dcolumn, drow)
      @column = dcolumn
      @row = drow
    end

    def can_move_to_field?(dcolumn, drow)
      !(column == dcolumn && drow == row) &&
      (0..7).include?(dcolumn) && (0..7).include?(drow)
    end

    def can_take_on_field?(dcolumn, drow)
      can_move_to_field?(dcolumn, drow)
    end

    def fields_between(dcolumn, drow)
      return [] unless can_move_to_field?(drow, dcolumn)
      if same_row?(drow)
        smaller, bigger = [column, dcolumn].sort
        (smaller+1..bigger-1).map{|c| [c, row] }
      elsif same_column?(dcolumn)
        smaller, bigger = [row, drow].sort
        (smaller+1..bigger-1).map{|r| [column, r] }
      elsif same_diagonal?(drow, dcolumn)
        smaller_r, bigger_r = [row, drow].sort
        smaller_c, bigger_c = [column, dcolumn].sort
        (smaller_r+1..bigger_r-1).to_a.zip((smaller_c+1..bigger_c-1).to_a)
      else
        []
      end
    end

    def can_en_passant?(board, color, dcolumn, drow)
      false
    end

    def can_be_promoted?
      false
    end

    def valid?
      (0..7).include?(column) && (0..7).include?(row)
    end

    def by_line(dcolumn, drow, range)
      same_row?(drow) && (column - dcolumn).abs <= range  ||
      same_column?(dcolumn) && (row - drow).abs <= range
    end

    def by_diagonal(dcolumn, drow, range)
      same_diagonal?(dcolumn, drow) &&
        (column - dcolumn).abs <= range
    end

    def white?
      color == Bchess::WHITE
    end

    def black?
      color == Bchess::BLACK
    end

    private

    def same_row?(drow)
      row == drow
    end

    def same_column?(dcolumn)
      column == dcolumn
    end

    def same_diagonal?(dcolumn, drow)
     (column - dcolumn).abs == (row - drow).abs
    end
  end
end
