describe Walletone do
  context '.logger' do
    it 'has logger' do
      expect(described_class.logger).to be_a(Logger)
    end
  end

  # let(:notifier) { notifier = Class.new; def notifier.notify *args; end }
  # let(:notifier) { double }

  describe 'Использует Bugsnag если он есть' do
    before do
      # Сбрасываем конфигурацию, чтобы она еще раз создалась
      Walletone::Configuration.instance_variable_set('@singleton__instance__', nil)
    end

    it 'должен найти и применить Bugsnag' do
      module ::Bugsnag
        def self.notify(*_args)
        end
      end
      expect(Walletone.config.error_notifier).to eq Bugsnag
    end

    after do
      Walletone::Configuration.instance_variable_set('@singleton__instance__', nil)
      Object.send(:remove_const, :Bugsnag)
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
