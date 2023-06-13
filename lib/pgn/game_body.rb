module Bchess
  module PGN
    class GameBody
      attr_reader :body, :moves, :board

      include BoardHelpers

      C_COLUMN = 2
      G_COLUMN = 6

      WHITE_ROW = 0
      BLACK_ROW = 7

      def initialize(body)
        @body = body
        @board = Bchess::Board.new
        @moves = []
      end

      def extract_moves
        @board.read_fen

        body.elements&.each do |move|
          if is_castle?(move)
            move_info = extract_castle(move)
          elsif is_move?(move)
            move_info = extract_move(move)
          else
            next
          end

          piece = move_info.fetch(:piece)
          column, row = piece.column, piece.row
          board.move(*move_info.values)
          @moves << move_info.merge( { piece: piece.class.new(piece.color, column, row) })
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

        if pieces.size != 1
          raise Bchess::InvalidMoveException.new("Too many or too few pieces to make move: #{info} : #{pieces.size}")
        end

        pieces.first
      end

      def extract_castle(move)
        move_text = move.text_value
        info = return_move_information(move_text, true)

        if C_COLUMN == move_text.split('-').size
          column = G_COLUMN
          row = is_white?(info) ? WHITE_ROW : BLACK_ROW
        else
          column = C_COLUMN
          row = is_white?(info) ? WHITE_ROW : BLACK_ROW
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
