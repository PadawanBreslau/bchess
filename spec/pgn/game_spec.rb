require 'spec_helper'

RSpec.describe Bchess::PGN::Game do
  context 'raeding a file and create Game object' do
    it 'should parse a file with single game' do
      file = Bchess::PGN::PGNFile.new('./spec/pgn/examples/StanislawZawadzkiOne.pgn')
      parser = Bchess::PGN::Parser.new(file)
      parsed_game = parser.parse.first
      game = Bchess::PGN::Game.new(parsed_game)

      expect(game.header).to be_kind_of(Bchess::PGN::GameHeader)
      expect(game.header.player_white).to eq 'Zawadzki, Stanislaw'
      expect(game.header.player_black).to eq 'Przybylski, Wojciech'
    end
  end
end

