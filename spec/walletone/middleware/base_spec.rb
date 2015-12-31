require 'walletone/middleware'
require 'walletone/middleware/base'

describe Walletone::Middleware::Base do
  let(:middleware) { described_class.new }
  let!(:params) { { cp1251: 'привет'.encode('windows-1251') } }
  subject { Rack::MockRequest.new(middleware).post('/', params: params) }

  it do
    expect(subject.status).to eq 200
  end

  it do
    expect(subject.body).to eq 'WMI_RESULT=RETRY&WMI_DESCRIPTION=Walletone middleware perform method is not implemented'
  end

  # Walletone.notify_callback = lambda do |resp, env|
  # expect(resp.param(:cp1251).first).to eq('привет')
  # resp.ok
  # end
  # end
end
