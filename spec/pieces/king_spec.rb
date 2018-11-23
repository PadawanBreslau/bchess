require 'spec_helper'

RSpec.describe Bchess::King do
  context 'creating piece' do
    it 'should create king' do
      expect(Bchess::King.new(Bchess::BLACK, 0, 0).valid?).to be
    end

    it 'should not create king if invalid' do
      expect(Bchess::King.new(Bchess::BLACK, 0, 9).valid?).not_to be
      expect(Bchess::King.new(Bchess::BLACK, 9, 0).valid?).not_to be
    end
  end

  context 'moving' do
    it 'should move' do
      king = Bchess::King.new(Bchess::BLACK, 1, 1)
      expect(king.can_move_to_field?(0, 0)).to be
      expect(king.can_move_to_field?(0, 1)).to be
      expect(king.can_move_to_field?(0, 2)).to be
      expect(king.can_move_to_field?(1, 0)).to be
      expect(king.can_move_to_field?(1, 2)).to be
      expect(king.can_move_to_field?(2, 0)).to be
      expect(king.can_move_to_field?(2, 1)).to be
      expect(king.can_move_to_field?(2, 1)).to be
    end

    it 'shouldnt move' do
      king = Bchess::King.new(Bchess::BLACK, 1, 1)
      expect(king.can_move_to_field?(1, 1)).to be_falsey
      expect(king.can_move_to_field?(3, 1)).to be_falsey
      expect(king.can_move_to_field?(1, 3)).to be_falsey
    end
  end
end
