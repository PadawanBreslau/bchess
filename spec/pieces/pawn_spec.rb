require 'spec_helper'

RSpec.describe Bchess::Pawn do
  context 'creating piece' do
    it 'should create pawn' do
      expect(Bchess::Pawn.new(Bchess::BLACK,0,1).valid?).to be
      expect(Bchess::Pawn.new(Bchess::BLACK,0,6).valid?).to be
    end

    it 'should not create pawn if invalid' do
      expect(Bchess::Pawn.new(Bchess::WHITE,0,0).valid?).not_to be
      expect(Bchess::Pawn.new(Bchess::BLACK,8,0).valid?).not_to be
    end
  end

  context 'moving' do
    it 'should move' do
      pawn = Bchess::Pawn.new(Bchess::WHITE,1,1)
      expect(pawn.can_move_to_field?(1,2)).to be
      expect(pawn.can_move_to_field?(1,3)).to be
      expect(pawn.can_move_to_field?(1,0)).not_to be
      pawn = Bchess::Pawn.new(Bchess::BLACK,1,1)
      expect(pawn.can_move_to_field?(1,0)).to be
      expect(pawn.can_move_to_field?(1,2)).not_to be
      expect(pawn.can_move_to_field?(1,3)).not_to be
    end

    it 'shouldnt move' do
      pawn = Bchess::Pawn.new(Bchess::BLACK,1,1)
      expect(pawn.can_move_to_field?(1,1)).to be_falsey
      expect(pawn.can_move_to_field?(3,1)).to be_falsey
      expect(pawn.can_move_to_field?(1,3)).to be_falsey
    end

    it 'should take' do
      pawn = Bchess::Pawn.new(Bchess::WHITE,1,1)
      expect(pawn.can_take_on_field?(2,2)).to be
      expect(pawn.can_take_on_field?(0,2)).to be
      pawn = Bchess::Pawn.new(Bchess::BLACK,1,1)
      expect(pawn.can_take_on_field?(2,0)).to be
      expect(pawn.can_take_on_field?(0,0)).to be
    end

    it 'should not take' do
      pawn = Bchess::Pawn.new(Bchess::WHITE,1,1)
      expect(pawn.can_take_on_field?(2,1)).not_to be
      expect(pawn.can_take_on_field?(0,0)).not_to be
      pawn = Bchess::Pawn.new(Bchess::BLACK,1,1)
      expect(pawn.can_take_on_field?(2,2)).not_to be
      expect(pawn.can_take_on_field?(0,2)).not_to be
    end
  end
end

