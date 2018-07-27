module Bchess
  module PGN
    class GameHeader
      attr_reader :header, :player_white, :player_black

      def initialize(header)
        @header = header
      end

      def player_white
        @player_white ||= values["White"]
      end

      def player_black
        @player_black ||= values["Black"]
      end

      def elo_white
        @elo_white ||= values["WhiteElo"]
      end

      def elo_black
        @elo_black ||= values["BlackElo"]
      end

      def event
        @event ||= values["Event"]
      end

      def site
        @site ||= values["Site"]
      end

      def date
        @date ||= values["Date"]
      end

      def round
        @round ||= values["Round"]
      end

      def eco
        @eco ||= values["Eco"]
      end

      def result
        @result ||= values["Result"]
      end

      def values
        @values ||= header.create_value_hash
      end
    end
  end
end
