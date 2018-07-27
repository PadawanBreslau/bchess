module Bchess
  module PGN
    class PGNFile
      attr_accessor :filepath, :games, :content

      def initialize(filepath)
        @filepath = filepath
      end

      def load_games
        file = File.open(filepath, "rt")
        @content = file.read
      end

      def parse_games
        pgn_content = Bchess::PGN::FileContent.new(content)
        begin
          @games = pgn_content.parse_games
        rescue BChess::InvalidPGNFile
          return false
        ensure
          file.close
        end
        true
      end
    end
  end
end
