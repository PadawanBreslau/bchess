module Bchess
  module PGN
    class MoveInfoParser
      attr_accessor :info, :move, :castle, :move_string

      CHECK = '+'.freeze
      TAKE = 'x'.freeze
      TAKE_2 = ':'.freeze
      MATE = '#'.freeze
      PROMOTION = '='.freeze

      def initialize(move, castle)
        @move = move
        @castle = castle
      end

      def parse_move_string
        info = {}
        info.merge!(extract_promotion)
        move_split = @move.split('.')

        info.merge!(basic_move_data(move_split))
        return info if @castle

        move_string.tr!('+x:#', '')
        info.merge!(additional_info(move_string))
      end

      private

      def additional_info(move_string)
        {
          piece_type: extract_piece_type(move_string),
          column: extract_column(move_string),
          row: extract_row(move_string),
          additional_info: extract_additional_info(move_string)
        }
      end

      def extract_piece_type(move_string)
        if move_string.size == 2 || move_string.size && pawn_taking?(move_string)
          Bchess::Pawn
        else
          get_piece_from_letter(move_string[0])
        end
      end

      def pawn_taking?(move_string)
        move_string[0].ord >= 'a'.ord && move_string[0].ord <= 'h'.ord
      end

      def extract_column(move_string)
        move_string[move_string.size - 2]
      end

      def extract_row(move_string)
        move_string[move_string.size - 1]
      end

      def extract_additional_info(move_string)
        if (move_string.size == 3) && pawn_taking?(move_string)
          move_string[0]
        elsif move_string.size == 4
          move_string[1]
        end
      end

      def extract_promotion
        promotion = @move.split(PROMOTION)

        if promotion.size == 2
          @move = promotion.first
          { promoted_piece: get_piece_from_letter(promotion.last[0]) }
        else
          {}
        end
      end

      def basic_move_data(move_split)
        @move_string = move_split.last.strip

        raise InvalidMoveException, 'Wrong move description' if move_string.size < 2

        color = move_split.size == 2 ? Bchess::WHITE : Bchess::BLACK
        number = move_split.first.strip if move_split.size == 2
        {
          piece_color: color,
          move_number: number,
          check: move_string.include?(CHECK),
          take: move_string.include?(TAKE) || move_string.include?(TAKE_2),
          mate: move_string.include?(MATE)
        }
      end

      def get_piece_from_letter(letter)
        {
          'K' => Bchess::King,
          'Q' => Bchess::Queen,
          'R' => Bchess::Rook,
          'B' => Bchess::Bishop,
          'N' => Bchess::Knight
        }[letter]
      end
    end
  end
end
