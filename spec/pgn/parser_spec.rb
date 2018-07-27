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
end

