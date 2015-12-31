require 'walletone/form'

describe Walletone::Form do
  let(:payment) { Fabricate(:payment).sign! 'somekey' }

  subject { described_class.new payment }

  describe '#checkout_url' do
    it { expect(subject.checkout_url).to eq Walletone.config.web_checkout_url }
  end

  describe '#hidden_fields_tags' do
    it { expect(subject.hidden_fields_tags).to include 'input name' }
  end

  describe '#options' do
    it { expect(subject.options).to be_a Hash }
  end
end
