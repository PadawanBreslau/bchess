module Bchess
  module PGN
    class Game
      attr_accessor :header, :body, :moves

      def initialize(parsed_game)
        @header = Bchess::PGN::GameHeader.new(parsed_game.elements.first)
        @body = Bchess::PGN::GameBody.new(parsed_game.elements.last)
      end

      def convert_body_to_moves
        body.extract_moves
        @moves = body.moves
        true
      end
    end
  end
end
