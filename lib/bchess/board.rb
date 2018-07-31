require_relative 'helpers/board_helpers'
require_relative 'helpers/castle_helpers'
require_relative 'helpers/en_passant_helpers'
require_relative 'helpers/fen_helpers'
require_relative 'helpers/validations'

module Bchess
  class Board
    include BoardHelpers
    include FenHelpers
    include CastleHelpers
    include EnPassantHelpers
    include Validations

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
        long_pawn_move(piece, column, row)
      elsif piece.can_move_to_field?(column,row)
        piece.move(column, row)
      elsif piece.can_take_on_field?(column,row)
        piece.move(column, row)
      else
        return false
      end

      update_info(piece, column, row)
      validate_move
    rescue RuntimeError
      false
    end

    def get_possible_pieces(info)
      @pieces.select{|p| p.can_move?(info, self)}
    end

    def update_info(piece, column, row)
      update_castles_after_move(piece) if piece.moved
      change_halfmove_clock(piece)
      change_to_move
      change_move_number if piece.color == Bchess::BLACK
      remove_old_piece(column, row, piece.color) if !!at(column, row)
    end


    def execute_promotion(piece, column, row, promoted_piece)
      raise RuntimeError.new("Promotion Not Specified") if promoted_piece.nil? || !(promoted_piece < Bchess::Piece)
      pieces.delete(piece)
      promoted = promoted_piece.new(piece.color, column, row)
      promoted.moved = true if promoted_piece == Bchess::Rook
      pieces << promoted
    end

    def transform_field(field)
      [field.chars.first.ord - 97, field.chars.last.to_i - 1]
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

    def king(color)
      @pieces.select{ |p| p.class == Bchess::King && p.color == color }.first
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


    def king_attacked(color)
      _king = king(color)
      _pieces = _other_pieces(color)

      _pieces.any?{|p| attacks?(p, _king)}
    end

    def attacks?(piece, king)
      piece.can_take_on_field?(king.column, king.row) &&
        piece.fields_between(king.column, king.row).none?{|f| at(*f)}
    end

    def _pieces(color)
      @pieces.select{ |p| p.color == color }
    end

    def _other_pieces(color)
      @pieces.select{ |p| p.color != color }
    end
  end
end
