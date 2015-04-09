require 'walletone/middleware'
require 'walletone/middleware/callback'

describe Walletone::Middleware::Callback do
  let(:callback) { -> (notify, env) { } }
  let(:middleware) { described_class.new callback }
  let!(:params) { { cp1251: 'привет'.encode('windows-1251') } }
  subject! { Rack::MockRequest.new(middleware).post('/', params: params ) }

  it do
    expect(subject.body).to eq 'WMI_RESULT=OK' 
  end

end
