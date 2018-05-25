require 'spec_helper'

RSpec.describe Bchess::Rook do
  context 'creating piece' do
    it 'should create rook' do
      expect(Bchess::Rook.new(Bchess::BLACK, 0,0).valid?).to be
    end

    it 'should not create rook if invalid' do
      expect(Bchess::Rook.new(Bchess::BLACK,0,9).valid?).not_to be
      expect(Bchess::Rook.new(Bchess::BLACK,9,0).valid?).not_to be
    end
  end

  context 'moving' do
    it 'should move' do
      rook = Bchess::Rook.new(Bchess::BLACK,1,1)
      expect(rook.can_move_to_field?(0,1)).to be
      expect(rook.can_move_to_field?(2,1)).to be
      expect(rook.can_move_to_field?(3,1)).to be
      expect(rook.can_move_to_field?(4,1)).to be
      expect(rook.can_move_to_field?(5,1)).to be
      expect(rook.can_move_to_field?(6,1)).to be
      expect(rook.can_move_to_field?(7,1)).to be
      expect(rook.can_move_to_field?(1,0)).to be
      expect(rook.can_move_to_field?(1,2)).to be
      expect(rook.can_move_to_field?(1,3)).to be
      expect(rook.can_move_to_field?(1,4)).to be
      expect(rook.can_move_to_field?(1,5)).to be
      expect(rook.can_move_to_field?(1,6)).to be
      expect(rook.can_move_to_field?(1,7)).to be
    end

    it 'shouldnt move' do
      rook = Bchess::Rook.new(Bchess::BLACK,1,1)
      expect(rook.can_move_to_field?(1,1)).to be_falsey
      expect(rook.can_move_to_field?(3,2)).to be_falsey
      expect(rook.can_move_to_field?(2,3)).to be_falsey
      expect(rook.can_move_to_field?(0,0)).to be_falsey
    end

    it 'should have fields between' do
      rook = Bchess::Rook.new(Bchess::BLACK,1,1)
      expect(rook.fields_between(1,1)).to be_empty
      expect(rook.fields_between(2,2)).to be_empty
      expect(rook.fields_between(1,2)).to be_empty
      expect(rook.fields_between(3,1)).to eq [[2, 1]]
      expect(rook.fields_between(6,1)).to eq [[2, 1], [3, 1], [4, 1], [5, 1]]
      expect(rook.fields_between(6,6)).to be_empty
    end
  end
end

