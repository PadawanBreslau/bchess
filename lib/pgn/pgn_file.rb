require 'byzantion_chess'

class PgnFile
  attr_accessor :filepath, :games

  def initialize(filepath)
  	raise ByzantionChess::InvalidPGNFile.new("Not a pgn extension") unless filepath[-3..-1] == 'pgn'  # TODO Fole.extname
    @filepath = filepath
  end

  def load_and_parse_games
    raise ByzantionChess::InvalidPGNFile.new("PgnFileNotFound") unless File.exists?(filepath)
    file = File.open(filepath, "rt")
    content = file.read
    raise ByzantionChess::InvalidPGNFile.new("PgnFileEmpty") if content.blank?
    pgn_content = PgnFileContent.new(content)
    begin
      @games = pgn_content.parse_games
    rescue ByzantionChess::InvalidPGNFile => e
      return false
    ensure
      file.close
    end
    true
  end
end
