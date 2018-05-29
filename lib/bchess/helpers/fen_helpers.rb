module Bchess
  module FenHelpers
    def fen_hash
      {
        'k': {klass: Bchess::King, color: Bchess::BLACK},
        'q': {klass: Bchess::Queen, color: Bchess::BLACK},
        'r': {klass: Bchess::Rook, color: Bchess::BLACK},
        'b': {klass: Bchess::Bishop, color: Bchess::BLACK},
        'n': {klass: Bchess::Knight, color: Bchess::BLACK},
        'p': {klass: Bchess::Pawn, color: Bchess::BLACK},
        'K': {klass: Bchess::King, color: Bchess::WHITE},
        'Q': {klass: Bchess::Queen, color: Bchess::WHITE},
        'R': {klass: Bchess::Rook, color: Bchess::WHITE},
        'B': {klass: Bchess::Bishop, color: Bchess::WHITE},
        'N': {klass: Bchess::Knight, color: Bchess::WHITE},
        'P': {klass: Bchess::Pawn, color: Bchess::WHITE},
      }
    end

    def update_fen
      result = ''
      7.downto(0) do |i|
        line_pieces = pieces.select{ |p| p.row == i }
        one_line = create_fen_line(line_pieces)
        result << one_line
        result << '/' unless i == 0
      end
      result.concat(additional_info)
    end

    def create_fen_line(pieces)
      line = ''
      counter = 0

      0.upto(7) do |i|
        piece = pieces.select{ |p| p.column == i }.first
        if !!piece
          if counter > 0
            line.concat(counter.to_s)
            counter = 0
            line.concat(to_fen(piece))
          else
            line.concat(to_fen(piece))
          end
        else
          counter += 1
        end
      end
      line.concat(counter.to_s) if counter > 0
      line
    end

    def to_fen(piece)
      fen_hash.key({ :klass => piece.class, :color => piece.color }).to_s
    end

    def additional_info
      " #{to_move} #{castles} #{en_passant} #{halfmove_clock} #{move_number}"
    end
  end
end
