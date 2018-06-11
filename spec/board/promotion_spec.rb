require 'spec_helper'

RSpec.describe Bchess::Board do
  context 'promotion' do
    it 'should promote a piece of same color' do
      fen = '8/P3k3/8/8/4K3/8/8/8 w - - 0 1'
      board = Bchess::Board.new(fen)
      expect{ board.read_fen }.not_to raise_error
      expect(board.valid_position?).to be

      piece = board.at(0,6)
      expect(board.move(piece, 0 , 7)).not_to be
    end

    it 'should promote a piece of same color' do
      fen = '8/P3k3/8/8/4K3/8/8/8 w - - 0 1'
      board = Bchess::Board.new(fen)
      expect{ board.read_fen }.not_to raise_error
      expect(board.valid_position?).to be

      piece = board.at(0,6)
      expect(board.move(piece, 0 , 7, Bchess::Queen)).to be
      expect(board.fen).to eq 'Q7/4k3/8/8/4K3/8/8/8 b - - 0 1'
    end

    it 'should promote a piece of same color' do
      fen = '8/4k3/8/8/4K3/8/p7/8 b - - 0 1'
      board = Bchess::Board.new(fen)
      expect{ board.read_fen }.not_to raise_error
      expect(board.valid_position?).to be

      piece = board.at(0,1)
      expect(board.move(piece, 0 , 0, Bchess::Rook)).to be
      expect(board.fen).to eq '8/4k3/8/8/4K3/8/8/r7 w - - 0 2'

      expect(board.at(0,0).moved).to be
    end
  end
end
