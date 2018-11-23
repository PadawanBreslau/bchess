require 'spec_helper'

RSpec.describe Bchess::Bishop do
  context 'creating piece' do
    it 'should create bishop' do
      expect(Bchess::Bishop.new(Bchess::WHITE, 0, 0).valid?).to be
    end

    it 'should not create bishop if invalid' do
      expect(Bchess::Bishop.new(Bchess::WHITE, 0, 9).valid?).not_to be
      expect(Bchess::Bishop.new(Bchess::BLACK, 9, 0).valid?).not_to be
    end
  end

  context 'moving' do
    it 'should move' do
      bishop = Bchess::Bishop.new(Bchess::WHITE, 1, 1)
      expect(bishop.can_move_to_field?(0, 0)).to be
      expect(bishop.can_move_to_field?(2, 2)).to be
      expect(bishop.can_move_to_field?(3, 3)).to be
      expect(bishop.can_move_to_field?(4, 4)).to be
      expect(bishop.can_move_to_field?(5, 5)).to be
      expect(bishop.can_move_to_field?(6, 6)).to be
      expect(bishop.can_move_to_field?(7, 7)).to be
      expect(bishop.can_move_to_field?(2, 0)).to be
      expect(bishop.can_move_to_field?(0, 2)).to be
      expect(bishop.can_move_to_field?(0, 0)).to be
    end

    it 'should move - 2' do
      bishop = Bchess::Bishop.new(Bchess::WHITE, 4, 4)
      expect(bishop.can_move_to_field?(3, 3)).to be
      expect(bishop.can_move_to_field?(3, 5)).to be
      expect(bishop.can_move_to_field?(5, 3)).to be
      expect(bishop.can_move_to_field?(5, 5)).to be
      expect(bishop.can_move_to_field?(2, 2)).to be
      expect(bishop.can_move_to_field?(6, 6)).to be
      expect(bishop.can_move_to_field?(2, 6)).to be
      expect(bishop.can_move_to_field?(6, 2)).to be
    end

    it 'shouldnt move' do
      bishop = Bchess::Bishop.new(Bchess::WHITE, 1, 1)
      expect(bishop.can_move_to_field?(1, 1)).to be_falsey
      expect(bishop.can_move_to_field?(3, 2)).to be_falsey
      expect(bishop.can_move_to_field?(2, 3)).to be_falsey
    end

    it 'should have fields between' do
      queen = Bchess::Bishop.new(Bchess::BLACK, 1, 1)
      expect(queen.fields_between(1, 1)).to be_empty
      expect(queen.fields_between(2, 2)).to be_empty
      expect(queen.fields_between(1, 2)).to be_empty
      expect(queen.fields_between(6, 1)).to be_empty
      expect(queen.fields_between(6, 6).sort).to eq [[2, 2], [3, 3], [4, 4], [5, 5]].sort
    end
  end
end
