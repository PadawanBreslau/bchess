require 'spec_helper'

RSpec.describe Bchess::PGN::Parser do
  context 'passing string to parser' do
    it 'passing empty string to parser' do
      parser = Bchess::PGN::Parser.new('')
      expect{parser.parse}.not_to raise_error
    end

    it 'passing random string' do
      parser = Bchess::PGN::Parser.new('adasdsadsads')
      expect{parser.parse}.to raise_error(Bchess::PGN::ParserException)
    end
  end

  context 'raeding a file' do
    it 'should parse a file with single game' do
      file = Bchess::PGN::PGNFile.new('./spec/pgn/examples/StanislawZawadzkiOne.pgn')
      parser = Bchess::PGN::Parser.new(file)
      parsed_games = parser.parse
      game = parsed_games.first

      expect(game).to be_kind_of Sexp::PGame
    end
  end
end

