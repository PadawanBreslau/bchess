require 'spec_helper'

RSpec.describe Bchess::Board do
  context 'setting up position with FEN' do
    it 'should create empty board' do
      board = Bchess::Board.new
      expect(board.pieces).to be_empty
      expect(board.fen).to eq Bchess::START_FEN
      expect(board.valid_position?).not_to be
      expect{ board.read_fen }.not_to raise_error
      expect(board.valid_position?).to be
    end

    it 'should not make invalid move' do
      board = Bchess::Board.new
      expect(board.pieces).to be_empty
      expect(board.fen).to eq Bchess::START_FEN
      expect(board.valid_position?).not_to be
      expect{ board.read_fen }.not_to raise_error

      old_fen = board.fen
      expect(board.move(board.at(1,1), 4 , 4)).not_to be
      expect(board.fen).to eq Bchess::START_FEN
      expect(board.update_fen).to eq old_fen
    end

    it 'should change fen after valid move' do
      board = Bchess::Board.new
      expect(board.pieces).to be_empty
      expect(board.fen).to eq Bchess::START_FEN
      expect(board.valid_position?).not_to be
      expect{ board.read_fen }.not_to raise_error

      old_fen = board.fen
      piece = board.at(4,1)
      expect(board.move(piece, 4 , 3)).to be
      expect(board.fen).not_to eq Bchess::START_FEN
      expect(board.fen).to eq 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'

      piece = board.at(2, 6)
      expect(board.move(piece, 2 , 4)).to be
      expect(board.fen).to eq 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2'

      piece = board.at(6, 0)
      expect(board.move(piece, 5 , 2)).to be
      expect(board.fen).to eq 'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'

      piece = board.at(6, 7)
      expect(board.move(piece, 5 , 5)).to be
      expect(board.fen).to eq 'rnbqkb1r/pp1ppppp/5n2/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3'

      piece = board.at(5, 0)
      expect(board.move(piece, 2 , 3)).to be
      expect(board.fen).to eq 'rnbqkb1r/pp1ppppp/5n2/2p5/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3'

      piece = board.at(1, 7)
      expect(board.move(piece, 2 , 5)).to be
      expect(board.fen).to eq 'r1bqkb1r/pp1ppppp/2n2n2/2p5/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4'

      piece = board.at(4, 0)
      expect(board.move(piece, 6, 0)).to be
      expect(board.fen).to eq 'r1bqkb1r/pp1ppppp/2n2n2/2p5/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4'

      piece = board.at(4, 6)
      expect(board.move(piece, 4, 5)).to be
      expect(board.fen).to eq 'r1bqkb1r/pp1p1ppp/2n1pn2/2p5/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 0 5'
    end
  end
end
