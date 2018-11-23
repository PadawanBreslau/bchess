module FieldBetweenHelpers
  def row_fields(dcolumn, _drow)
    smaller, bigger = [column, dcolumn].sort
    (smaller + 1..bigger - 1).map { |c| [c, row] }
  end

  def column_fields(_dcolumn, drow)
    smaller, bigger = [row, drow].sort
    (smaller + 1..bigger - 1).map { |r| [column, r] }
  end

  def diagonal_fields(dcolumn, drow)
    fields = []
    if dcolumn > column
      if drow > row
        (dcolumn - column - 1).times do |i|
          fields << [dcolumn - (i + 1), drow - (i + 1)]
        end
      else
        (dcolumn - column - 1).times do |i|
          fields << [dcolumn - (i + 1), drow + (i + 1)]
        end
      end
    else
      if drow > row
        (column - dcolumn - 1).times do |i|
          fields << [dcolumn + (i + 1), drow - (i + 1)]
        end
      else
        (column - dcolumn - 1).times do |i|
          fields << [dcolumn + (i + 1), drow + (i + 1)]
        end
      end
    end
    fields
  end

  def fields_between(dcolumn, drow)
    return [] unless can_move_to_field?(dcolumn, drow)

    if same_row?(drow)
      row_fields(dcolumn, drow)
    elsif same_column?(dcolumn)
      column_fields(dcolumn, drow)
    elsif same_diagonal?(dcolumn, drow)
      diagonal_fields(dcolumn, drow)
    else
      []
    end
  end
end
