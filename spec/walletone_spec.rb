describe Walletone do
  context '.logger' do
    it 'has logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end
end
