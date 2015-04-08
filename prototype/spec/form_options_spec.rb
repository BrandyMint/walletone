require 'rails_helper'

describe W1::FormOptions do
  let(:order) { create :order }

  subject { described_class.new order }

  describe '#generate' do
    it do
      expect(subject.generate).to be_a Array
    end
  end
end

