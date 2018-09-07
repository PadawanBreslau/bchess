module Validations
  def validate_move
    if !valid_position?
      read_fen
      false
    else
      @fen = write_fen
      true
    end
  end

  def valid_position?
    kings_present? &&
      !king_attacked(just_moved)
  end
end
