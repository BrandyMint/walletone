describe Walletone::NotifyCallback do
  let(:stack)    { described_class.new }
  let(:request)  { Rack::MockRequest.new(stack) }
  let(:response) { request.get('/') }

  it 'works' do
    expect(response.body).to eq('Hello Rack!')
  end
end
