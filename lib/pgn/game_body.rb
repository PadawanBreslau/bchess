module Bchess
  module PGN
    class GameBody
      attr_reader :body

      def initialize(body)
        @body = body
      end
    end
  end
end
