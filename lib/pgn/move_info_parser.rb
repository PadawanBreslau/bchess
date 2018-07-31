module Bchess
  module PGN
    class MoveInfoParser
      attr_accessor :info, :move, :castle

      def initialize(move_string, castle)
        @move = move_string
        @castle = castle
      end

      def promotion?(info)
        promotion = @move.split("=")
        if promotion.size == 2
          @move = promotion.first
          info[:promoted_piece] = get_piece_from_letter(promotion.last[0])
        end
        info
      end

      def basic_move_data(move_split, move_string)
        Hash.new.tap do |info|
          info[:piece_color] = move_split.size == 2 ? Bchess::WHITE : Bchess::BLACK
          info[:move_number] = move_split.first.strip if move_split.size == 2
          raise InvalidMoveException.new("Wrong move description") if move_string.size < 2
          info[:check] = move_string.include?('+')
          info[:take] = move_string.include?('x') || move_string.include?(':')
          info[:mate] = move_string.include?('#')
        end
      end

      def parse_move_string
        info = Hash.new
        info = promotion?(info)
        move_split = @move.split('.')
        move_string = move_split.last.strip
        info.merge!(basic_move_data(move_split, move_string))
        return info if @castle
        move_string = move_string.delete('+').delete('x').delete(':').delete('#')
        info.merge!(additional_info(move_string))
      end

      def additional_info(move_string)
        Hash.new.tap do |info|
          if(2 == move_string.size)
            info[:piece_type] = Bchess::Pawn
            info[:column] = move_string[0]
            info[:row] = move_string[1]
          elsif(3 == move_string.size)
            if move_string[0].ord >= 'a'.ord && move_string[0].ord <= 'h'.ord  # "cxd4"
              info[:additional_info] = move_string[0]
              info[:piece_type] = Bchess::Pawn
            else
              info[:piece_type] = get_piece_from_letter(move_string[0])
            end
            info[:column] = move_string[1]
            info[:row] = move_string[2]

          elsif(4 == move_string.size)
            info[:piece_type] = get_piece_from_letter(move_string[0])
            info[:column] = move_string[2]
            info[:row] = move_string[3]
            info[:additional_info] = move_string[1]
          end
        end
      end

      def get_piece_from_letter(letter)
        {
          "K" => Bchess::King,
          "Q" => Bchess::Queen,
          "R" => Bchess::Rook,
          "B" => Bchess::Bishop,
          "N" => Bchess::Knight
        }[letter]
      end
    end
  end
end
