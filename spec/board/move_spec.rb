require 'spec_helper'

RSpec.describe Bchess::Board do
  context 'basic moves' do
    it 'should move a king' do
      board = Bchess::Board.new
      board.to_move = Bchess::WHITE
      king_w = Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << king_w
      king_b = Bchess::King.new(Bchess::BLACK, 5 ,5)
      board.pieces << king_b

      expect(board.valid_position?).to be
      expect(board.move(king_w, 2 , 2)).to be
      expect(board.move(king_b, 4 , 4)).to be
      expect(board.move(king_w, 3 , 3)).not_to be
    end

    it 'should move a queen' do
      board = Bchess::Board.new
      board.to_move = Bchess::WHITE
      king_w = Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << king_w
      king_b = Bchess::King.new(Bchess::BLACK, 5 ,5)
      board.pieces << king_b
      queen = Bchess::Queen.new(Bchess::BLACK, 7 ,7)
      board.pieces << queen

      expect(board.valid_position?).to be
      expect(board.move(king_w, 2 , 2)).to be
      expect(board.move(queen, 7, 3)).to be
      expect(board.move(king_w, 3, 3)).not_to be
    end

    it 'should move a rook' do
      board = Bchess::Board.new
      board.to_move = Bchess::WHITE
      king_w = Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << king_w
      king_b = Bchess::King.new(Bchess::BLACK, 5 ,5)
      board.pieces << king_b
      rook = Bchess::Rook.new(Bchess::BLACK, 7 ,7)
      board.pieces << rook

      expect(board.valid_position?).to be
      expect(board.move(king_w, 2 , 2)).to be
      expect(board.move(rook, 7, 3)).to be
      expect(board.move(king_w, 3, 3)).not_to be
    end

    it 'should move a bishop' do
      board = Bchess::Board.new
      board.to_move = Bchess::WHITE
      king_w = Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << king_w
      king_b = Bchess::King.new(Bchess::BLACK, 5 ,5)
      board.pieces << king_b
      bishop = Bchess::Bishop.new(Bchess::BLACK, 7 ,6)
      board.pieces << bishop

      expect(board.valid_position?).to be
      expect(board.move(king_w, 2 , 2)).to be
      expect(board.move(bishop, 4, 3)).to be
      expect(board.move(king_w, 3, 3)).to be
    end

    it 'should be able to take a piece' do
      board = Bchess::Board.new
      board.to_move = Bchess::WHITE
      king_w = Bchess::King.new(Bchess::WHITE, 1, 1)
      board.pieces << king_w
      king_b = Bchess::King.new(Bchess::BLACK, 5 ,5)
      board.pieces << king_b
      queen = Bchess::Queen.new(Bchess::BLACK, 7 , 3)
      board.pieces << queen

      expect(board.valid_position?).to be
      expect(board.move(king_w, 2, 2)).to be
      expect(board.move(queen, 2, 3)).to be
      expect(board.move(king_w, 2, 3)).to be

      expect(board.pieces.size).to eq 2
    end
  end
end
