module Bchess
  module PGN
    class Game
      attr_accessor :header, :body, :moves

      def initialize(parsed_game)
        @header = Bchess::PGN::GameHeader.new(parsed_game.elements.first)
        @body = Bchess::PGN::GameBody.new(parsed_game.elements.last)
      end

      def convert_body_to_moves
        @moves = Hash.new { |hash, key| hash[key] = [] }
        extract_one_level_elements(@body.elements, Bchess::Board.new, 0)
        true
      end

      def extract_one_level_elements(elements, board, level = 0)
        elements.each do |move|
          if is_move?(move) || is_castle?(move)
            if is_castle?(move)
              move = create_castle(move, board)
            else
              move_text = move.text_value
              info = return_move_information(move_text)
              last_move_number = info[:move_number]
              piece = get_moved_piece(board, move, info)
              if promotion?(info)
                move = Bchess::Promotion.new(info[:promoted_piece], piece.field, info[:field], piece.color, last_move_number)
              elsif en_passant?(piece, board, info)
                move = Bchess::EnPassant.new(piece.field, info[:field], piece.color, last_move_number)
              else
                move = Bchess::Move.new(piece.field, info[:field], piece.color, last_move_number)
              end
            end
            set_variation_info(move, level)
            move.execute(board)
            @moves[level.to_s] << move
          elsif is_comment?(move)
            comment = move.return_comment
            last_move = @moves[level.to_s].last
            last_move.additional_info.comment = comment
          elsif is_variation?(move)
            extract_one_level_elements(move.elements.last.elements, Bchess::Board.new(board.fens[-2], board.not_to_move, board.additional_infos[-2].dup), level.next)
          end
        end
      end

      private

      def set_variation_info(move, level)
        variation_info = move.variation_info
        variation_info.level = level
        variation_info.previous_move = @moves[level.to_s].last || (@moves[(level-1).to_s][-2] if level > 0)
      end

      def en_passant?(piece, board, info)
        piece.kind_of?(Bchess::Pawn) && !board.piece_from(info[:field]) && info[:take]
      end

      def promotion?(info)
        info[:promoted_piece]
      end

      def get_moved_piece(board, move, info)
        pieces = board.get_possible_pieces(info[:piece_type], info[:piece_color], info[:field], info[:additional_info])
        raise Bchess::InvalidMoveException.new("Too many or too few pieces to make move: #{move.text_value} : #{pieces.size}") unless pieces.size == 1
        pieces.first
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

      def create_castle(move, board)
        move_text = move.text_value
        info = return_move_information(move_text, true)
        last_move_number = info[:move_number]
        start_field = is_white?(info) ? 'e1' : 'e8'

        if 2 == move_text.split('-').size
          destination = is_white?(info) ? 'g1' : 'g8'
        else
          destination = is_white?(info) ? 'c1' : 'c8'
        end
        Bchess::Castle.new(start_field, destination, info[:piece_color],last_move_number)
      end

      def return_move_information(move_text, castle=false)
        MoveInfoParser.new(move_text, castle).parse_move_string
      end

    end
  end
end
