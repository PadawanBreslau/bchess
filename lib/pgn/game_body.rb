require_relative '../bchess/helpers/board_helpers'

module Bchess

  module PGN
    class GameBody
      attr_reader :body, :moves, :board

      include BoardHelpers

      def initialize(body)
        @body = body
      end

      def extract_moves
        @board = Bchess::Board.new
        @board.read_fen
        @moves = []

        body.elements.each do |move|
          if is_castle?(move)
            move_info = extract_castle(move)
          elsif is_move?(move)
            move_info = extract_move(move)
          else
            next
          end

          #MAKE MOVE ON BOARD
          board.move(*move_info.values)
          @moves << move_info
        end
      end

      def extract_move(move)
        move_text = move.text_value
        info = return_move_information(move_text)

        piece = get_moving_piece(board, info)
        {
          piece: piece,
          column: to_column(info[:column]),
          row: to_row(info[:row]),
          promoted_piece: info[:promoted_piece]
        }
      end

      private

      def get_moving_piece(board, info)
        pieces = board.get_possible_pieces(info)

        raise Bchess::InvalidMoveException.new("Too many or too few pieces to make move: #{info} : #{pieces.size}") unless pieces.size == 1
        pieces.first
      rescue Bchess::InvalidMoveException => e
        board.print
        require 'pry'; binding.pry
        fail e
      end

      def extract_castle(move)
        move_text = move.text_value
        info = return_move_information(move_text, true)

        if 2 == move_text.split('-').size
          column = 6
          row = is_white?(info) ? 0 : 7
        else
          column = 2
          row = is_white?(info) ? 0 : 7
        end

        {
          piece: board.king(info[:piece_color]),
          column: column,
          row: row,
          promoted_piece: false
        }
      end

      def return_move_information(move_text,castle=false)
        Bchess::PGN::MoveInfoParser.new(move_text, castle).parse_move_string
      end

      def is_move?(move)
        move.kind_of?(Sexp::PMove)
      end

      def is_castle?(move)
        move.kind_of?(Sexp::PCastle)
      end

      def is_comment?(move)
        move.kind_of?(Sexp::PCommentWithBracket)
      end

      def is_variation?(move)
        move.kind_of?(Sexp::PVariation)
      end

      def is_white?(info)
        Bchess::WHITE == info[:piece_color]
      end

      def promotion?(info)
        info[:promoted_piece]
      end
    end
  end
end
