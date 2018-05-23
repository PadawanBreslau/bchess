class PgnFileContent
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def parse_games
    parsed_file = BChess::PGN::Parser.new(content).parse
    parsed_file.map do |one_game|
      # convert to game
    end
  end
end
