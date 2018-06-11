require_relative 'helpers/board_helpers'
require_relative 'helpers/fen_helpers'

module Bchess
  class Board
    include BoardHelpers
    include FenHelpers

    attr_accessor :fen, :to_move, :pieces, :castles, :en_passant, :halfmove_clock, :move_number

    def initialize(fen = Bchess::START_FEN, to_move = Bchess::WHITE)
      @fen = fen
      @to_move = to_move
      @move_number = 0
      @halfmove_clock = 0
      @pieces = []
      @en_passant = '-'
      @castles = '-'
    end

    def move(piece, column, row, promoted_piece = nil)
      return false if invalid_data?(piece, column, row)
      @en_passant = '-' unless en_passant_detected?(piece, column, row)
      if castle_detected?(piece, column)
        castle(piece, column, row)
      elsif promotion_detected?(piece, row)
        execute_promotion(piece, column, row, promoted_piece)
      elsif en_passant_detected?(piece, column, row)
        validate_en_passant(piece, column, row) && execute_en_passant(piece, column, row)
      elsif pawn_long_move_detected?(piece, row)
        piece.move(column, row)
        direction = piece.color == Bchess::WHITE ? 1 : -1
        @en_passant = field(column, (row + piece.row)/2 - direction)
      elsif piece.can_move_to_field?(column,row)
        piece.move(column, row)
      else
        return false
      end

      update_castles_after_move(piece) if piece.moved
      change_halfmove_clock(piece)
      change_to_move
      change_move_number if piece.color == Bchess::BLACK
      remove_old_piece(column, row, piece.color) if !!at(column, row)
      validate_move
    rescue RuntimeError
      false
    end

    def castle(piece, column, row)
      validate_castle(piece, column)
      update_castles_after_king_move(piece.color)
      execute_castle(piece, column, row)
    end

    def execute_promotion(piece, column, row, promoted_piece)
      raise RuntimeError.new("Promotion Not Specified") if promoted_piece.nil? || !(promoted_piece < Bchess::Piece)
      pieces.delete(piece)
      promoted = promoted_piece.new(piece.color, column, row)
      promoted.moved = true if promoted_piece == Bchess::Rook
      pieces << promoted
    end

    def execute_en_passant(piece, row, column)
      piece.move(row, column)
      remove_old_piece(*remove_en_passant(piece, *transform_field(@en_passant)), piece.color)
    end

    def remove_en_passant(piece, column, row)
      direction = piece.color == Bchess::WHITE ? 1 : -1
      [column, row - direction]
    end

    def transform_field(field)
      [field.chars.first.ord - 97, field.chars.last.to_i - 1]
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

    def change_halfmove_clock(piece)
      if piece.kind_of?(Bchess::Pawn)
        @halfmove_clock = 0
      else
        @halfmove_clock = halfmove_clock + 1
      end
    end

    def validate_move
      if !valid_position?
        read_fen
        false
      else
        @fen = update_fen
        true
      end
    end

    def validate_castle(piece, column)
      !piece.moved && !rook_moved?(piece, column) && fen_allows?(piece,column)
    end

    def validate_en_passant(piece, column, row)
      true
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

    def rook_moved?(piece, column)
      @castling_rook = if piece.row == 0
        if column == 6
          @short_castle = true
          at(7,0)
        else
          at(0,0)
        end
      else
        if column == 6
          @short_castle = true
          at(7,7)
        else
          at(0,7)
        end
      end
      @castling_rook&.moved
    end

    def execute_castle(piece, column, row)
      piece.move(column, row)
      lngth = @short_castle ? 2 : 3
      @castling_rook.move((@castling_rook.column - lngth).abs, row)
    end

    def valid_position?
      kings_present? &&
        !king_attacked(just_moved)
    end

    def at(column, row)
      pieces.select{|p| p.row == row && p.column == column}.first
    end

    def read_fen
      fen_pieces, fen_colors, fen_castles, fen_en_passant, fen_halfmove_clock, fen_move_number = fen.strip.split(" ")
      set_pieces(fen_pieces)
      set_to_move(fen_colors)
      set_castles(fen_castles)
      set_en_passant(fen_en_passant)
      set_halfmove_clock(fen_halfmove_clock)
      set_move_number(fen_move_number)
    end

    def print
      puts 'Pieces WHITE: '
      puts _pieces(Bchess::WHITE).map{|p| p.to_s }.join(', ')
      puts 'Pieces BLACK: '
      puts _pieces(Bchess::BLACK).map{|p| p.to_s }.join(', ')
    end

    private

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

    def remove_old_piece(column, row, color)
      taken_piece = _other_pieces(color).select{|p| p.row == row && p.column == column}.first
      pieces.delete(taken_piece)
    end

    def change_to_move
      @to_move = to_move == Bchess::WHITE ? Bchess::BLACK : Bchess::WHITE
    end

    def just_moved
      to_move == Bchess::WHITE ? Bchess::BLACK : Bchess::WHITE
    end

    def king(color)
      @pieces.select{ |p| p.class == Bchess::King && p.color == color }.first
    end

    def king_attacked(color)
      _king = king(color)
      _pieces = _other_pieces(color)

      _pieces.any?{|p| attacks?(p, _king)}
    end

    def attacks?(piece, king)
      piece.can_take_on_field?(king.column, king.row) &&
        piece.fields_between(king.column, king.row).none?{|c,r| pieces.any?{|p| p.at?(c,r) }}
    end

    def _pieces(color)
      @pieces.select{ |p| p.color == color }
    end

    def _other_pieces(color)
      @pieces.select{ |p| p.color != color }
    end
  end
end
