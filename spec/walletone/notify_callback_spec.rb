describe Walletone::NotifyCallback do
  let(:callback) { described_class.new }
  let(:response) do
    Rack::MockRequest.new(callback)
      .post('/', params: {
        cp1251: 'привет'.encode('windows-1251')
      })
  end

  after(:each) do
    Walletone.notify_callback = lambda { |r, env| r.retry }
  end

  context 'response' do
    it 'with retry by default' do
      expect(response.body).to eq('WMI_RESULT=RETRY')
    end

    it 'ok' do
      Walletone.notify_callback = lambda do |resp, env|
        resp.ok
      end

      expect(response.body).to eq('WMI_RESULT=OK')
    end
  end

  it 'encoding cp1251 to utf8' do
    Walletone.notify_callback = lambda do |resp, env|
      expect(resp.param(:cp1251).first).to eq('привет')
      resp.ok
    end
  end
end
