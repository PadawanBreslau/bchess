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
    end
  end
end
