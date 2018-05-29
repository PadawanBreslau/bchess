require 'spec_helper'

RSpec.describe Bchess::Board do
  context 'setting up position' do
    it 'should create empty board' do
      board = Bchess::Board.new
      expect(board.pieces).to be_empty
      expect(board.fen).to eq Bchess::START_FEN
      expect(board.valid_position?).not_to be
    end

    it 'empty board with two kings should be valid' do
      board = Bchess::Board.new
      board.pieces << Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << Bchess::King.new(Bchess::BLACK, 7, 7)

      expect(board.valid_position?).to be
    end

    it 'empty board with two kings should not be valid when kings near' do
      board = Bchess::Board.new
      board.pieces << Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << Bchess::King.new(Bchess::BLACK, 2, 2)

      expect(board.valid_position?).not_to be
    end

    it 'should disallow posiition with kind attacked' do
      board = Bchess::Board.new
      board.pieces << Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << Bchess::King.new(Bchess::BLACK, 7, 7)
      board.pieces << Bchess::Rook.new(Bchess::WHITE, 7, 1)

      expect(board.valid_position?).not_to be
    end

    it 'should allow posiition with kind attack blocked' do
      board = Bchess::Board.new
      board.pieces << Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << Bchess::King.new(Bchess::BLACK, 7, 7)
      board.pieces << Bchess::Rook.new(Bchess::WHITE, 7, 1)
      board.pieces << Bchess::Pawn.new(Bchess::WHITE, 7, 2)

      expect(board.valid_position?).to be
    end
  end
end
