describe Walletone do
  context '.logger' do
    it 'has logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end

  context '.notify_error' do
    let(:error) { StandardError.new }
    it do
      error_notifier = double
      allow(Walletone.config).to receive(:error_notifier).and_return error_notifier
      expect(error_notifier).to receive(:notify).with(error)
      expect(described_class.logger).to receive(:error)
      described_class.notify_error error
    end
  end
end
