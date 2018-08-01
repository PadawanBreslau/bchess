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

    def set_pieces(board)
      pieces.clear
      board.split("/").each_with_index do |line, index|
        column = 0
        line.each_char do |char|
          if char.to_i != 0
            column += char.to_i - 1
          else
            pieces << fen_hash[char.to_sym][:klass].new(fen_hash[char.to_sym][:color], column, 7-index)
          end
          column += 1
        end
      end
    end

    def fen_allows?(piece, column)
      if piece.color == Bchess::WHITE
        if column == 6
          castles.chars.include?('k')
        else
          castles.chars.include?('q')
        end
      else
        if column == 6
          castles.chars.include?('K')
        else
          castles.chars.include?('Q')
        end
      end
    end

    def to_fen(piece)
      fen_hash.key({ :klass => piece.class, :color => piece.color }).to_s
    end

    def change_halfmove_clock(piece)
      if piece.kind_of?(Bchess::Pawn)
        @halfmove_clock = 0
      else
        @halfmove_clock = halfmove_clock + 1
      end
    end

    def update_castles_after_move(piece)
      if piece == Bchess::King
        update_castles_after_king_move(piece.color)
      elsif piece == Bchess::Rook
        update_castles_after_rook_move(piece)
      end
    end

    def update_castles_after_king_move(color)
      if color == Bchess::WHITE
        @castles.gsub!('K', '').gsub!('Q', '')
      else
        @castles.gsub!('k', '').gsub!('q', '')
      end
    end

    def change_move_number
      @move_number = move_number + 1
    end

    def set_to_move(fen_colors)
      @to_move = fen_colors == 'w' ? Bchess::WHITE : Bchess::BLACK
    end

    def set_castles(fen_castles)
      @castles = fen_castles
    end

    def set_en_passant(fen_en_passant)
      @en_passant = fen_en_passant
    end

    def set_halfmove_clock(fen_halfmove_clock)
      @halfmove_clock = fen_halfmove_clock.to_i
    end

    def set_move_number(fen_move_number)
      @move_number = fen_move_number.to_i
    end

    def additional_info
      " #{to_move} #{castles} #{en_passant} #{halfmove_clock} #{move_number}"
    end
  end
end
