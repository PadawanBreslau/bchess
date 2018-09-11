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

  context 'reading and interpreting the file' do
    it 'should parse a file with single game' do
      file = Bchess::PGN::PGNFile.new('./spec/pgn/examples/StanislawZawadzkiOne.pgn')
      parser = Bchess::PGN::Parser.new(file)
      parsed_games = parser.parse
      game = Bchess::PGN::Game.new(parsed_games.first)

      game.convert_body_to_moves
      expect(game.moves).not_to be_empty
    end

    it 'should parse a file with single game - 2' do
      file = Bchess::PGN::PGNFile.new('./spec/pgn/examples/bakre_kadziolka.pgn')
      parser = Bchess::PGN::Parser.new(file)
      parsed_games = parser.parse
      game = Bchess::PGN::Game.new(parsed_games.first)

      game.convert_body_to_moves
      expect(game.moves).not_to be_empty
    end

    it 'should parse a file with multiple game', slow: true do
      file = Bchess::PGN::PGNFile.new('./spec/pgn/examples/StanislawZawadzki.pgn')
      parser = Bchess::PGN::Parser.new(file)
      parsed_games = parser.parse

      expect(parsed_games.size).to eq 500

      parsed_games.each do |parsed_game|
        game = Bchess::PGN::Game.new(parsed_game)

        game.convert_body_to_moves
        expect(game.moves).not_to be_empty
      end
    end

    it 'should parse a file with multiple game of Kasparov', slow: true do
      file = Bchess::PGN::PGNFile.new('./spec/pgn/examples/Kasparov.pgn')
      parser = Bchess::PGN::Parser.new(file)
      parsed_games = parser.parse

      #expect(parsed_games.size).to eq 2110

      parsed_games.each do |parsed_game|
        game = Bchess::PGN::Game.new(parsed_game)

        game.convert_body_to_moves
        expect(game.moves).not_to be_empty
      end
    end
  end
end
