require 'spec_helper'

RSpec.describe Bchess::Board do
  context 'en_passant' do
    it 'should do en-passant' do
      board = Bchess::Board.new
      expect{ board.read_fen }.not_to raise_error
      expect(board.valid_position?).to be

      piece = board.at(4, 1)
      board.move(piece, 4, 3)
      piece2 = board.at(4, 6)
      board.move(piece2, 4, 5)
      board.move(piece, 4, 4)
      piece3 = board.at(3, 6)
      board.move(piece3, 3, 4)
      board.move(piece, 3, 5)
      expect(board.at(3, 4)).not_to be
    end

    it 'should do en-passant with black' do
      board = Bchess::Board.new
      expect{ board.read_fen }.not_to raise_error
      expect(board.valid_position?).to be

      piece = board.at(0, 1)
      board.move(piece, 0, 2)
      piece2 = board.at(4, 6)
      board.move(piece2, 4, 4)
      board.move(piece, 0, 3)
      board.move(piece2, 4, 3)
      piece3 = board.at(3, 1)
      board.move(piece3, 3, 3)
      board.move(piece2, 3, 2)
      expect(board.at(3, 3)).not_to be
    end
  end
end
