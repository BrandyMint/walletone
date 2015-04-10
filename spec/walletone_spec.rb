describe Walletone do
  context '.logger' do
    it 'has logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end

  describe 'Использует Bugsnag если он есть' do
    before do
      ::Bugsnag = double
      # Сбрасываем конфигурацию, чтобы она еще раз создалась
      Walletone::Configuration.instance_variable_set('@singleton__instance__',nil)
    end

    it 'должен найти и применить Bugsnag' do
      expect(Walletone.config.error_notifier).to eq Bugsnag
    end

    after do
      ::Bugsnag = nil
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
