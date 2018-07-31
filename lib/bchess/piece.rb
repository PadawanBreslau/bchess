require_relative 'helpers/board_helpers'
require_relative 'helpers/validations'

module Bchess
  class Piece
    attr_reader :color, :column, :row

    include BoardHelpers
    include Validations

    def initialize(color, column, row)
      @color = color
      @column = column
      @row = row
    end

    def to_s
      name + field(column, row)
    end

    def moved
      false
    end

    def name
      raise Exception.new("Should be defined in subclass")
    end

    def at?(dcolumn, drow)
      column == dcolumn && row == drow
    end

    def move(dcolumn, drow)
      @column = dcolumn
      @row = drow
    end

    def can_move?(info, board)
      row = to_row(info[:row])
      column = to_column(info[:column])

      board.at(column, row)&.color != color &&
      kind_of?(info[:piece_type]) &&
      info[:piece_color] == color &&
      can_move_or_take?(column, row, board) &&
      additional_info?(info[:additional_info])
    end

    def can_move_or_take?(column, row, board)
      fields_between(column, row).none?{|f| board.at(*f)} &&
      (can_move_to_field?(column, row) ||
                         (can_take_on_field?(column, row) && !!board.at(column, row)) || can_en_passant_on_field?(column, row, board)
      )
    end

    def can_en_passant_on_field?(column, row, board)
      board.en_passant == field(column, row)
    end

    def valid_position_after?(dcolumn, drow, board)
    end

    def additional_info?(info)
      info.nil? || to_column(info) == column || to_row(info) == row
    end

    def can_move_to_field?(dcolumn, drow)
      !(column == dcolumn && drow == row) &&
      (0..7).include?(dcolumn) && (0..7).include?(drow)
    end

    def can_take_on_field?(dcolumn, drow)
      can_move_to_field?(dcolumn, drow)
    end

    def fields_between(dcolumn, drow)
      return [] unless can_move_to_field?(dcolumn, drow)
      if same_row?(drow)
        smaller, bigger = [column, dcolumn].sort
        (smaller+1..bigger-1).map{|c| [c, row] }
      elsif same_column?(dcolumn)
        smaller, bigger = [row, drow].sort
        (smaller+1..bigger-1).map{|r| [column, r] }
      elsif same_diagonal?(dcolumn, drow)
        fields = []
        if dcolumn > column
          if drow > row
            (dcolumn - column - 1).times do |i|
              fields << [dcolumn-(i+1), drow-(i+1)]
            end
          else
            (dcolumn - column - 1).times do |i|
              fields << [dcolumn-(i+1), drow+(i+1)]
            end
          end
        else
          if drow > row
            (column - dcolumn - 1).times do |i|
              fields << [dcolumn+(i+1), drow-(i+1)]
            end
          else
            (column - dcolumn - 1).times do |i|
              fields << [dcolumn+(i+1), drow+(i+1)]
            end
          end
        end
        fields
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
