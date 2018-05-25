require 'spec_helper'

RSpec.describe Bchess::Knight do
  context 'creating piece' do
    it 'should create knight' do
      expect(Bchess::Knight.new(Bchess::BLACK,0,0).valid?).to be
    end

    it 'should not create knight if invalid' do
      expect(Bchess::Knight.new(Bchess::BLACK,0,9).valid?).not_to be
      expect(Bchess::Knight.new(Bchess::BLACK,9,0).valid?).not_to be
    end
  end

  context 'moving' do
    it 'should move' do
      knight = Bchess::Knight.new(Bchess::BLACK,2,2)
      expect(knight.can_move_to_field?(0,1)).to be
      expect(knight.can_move_to_field?(1,0)).to be
      expect(knight.can_move_to_field?(4,1)).to be
      expect(knight.can_move_to_field?(4,3)).to be
      expect(knight.can_move_to_field?(3,4)).to be
      expect(knight.can_move_to_field?(0,3)).to be
      expect(knight.can_move_to_field?(1,4)).to be
      expect(knight.can_move_to_field?(3,0)).to be
    end

    it 'shouldnt move' do
      knight = Bchess::Knight.new(Bchess::BLACK,2,2)
      expect(knight.can_move_to_field?(2,3)).to be_falsey
      expect(knight.can_move_to_field?(2,4)).to be_falsey
      expect(knight.can_move_to_field?(2,2)).to be_falsey
      expect(knight.can_move_to_field?(0,0)).to be_falsey
    end
  end
end

