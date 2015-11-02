require 'walletone/recurrent'
require 'walletone/recurrent/payment'

describe Walletone::Recurrent::Payment do
  let(:merchant_id) { 127830694690 }
  let(:secret_key) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }

  subject { described_class.new( fields ) }

  let(:fields) do
    Walletone::Fields.new WMI_PAYMENT_AMOUNT: 123, WMI_MERCHANT_ID: merchant_id, WMI_CUSTOMER_ID: 123, WMI_RECURRING_AGREEMENT_URL: 'http://'
  end

  it 'works' do
    expect(subject.WMI_MERCHANT_ID).to eq(merchant_id)
  end

  it 'valid' do
    expect(subject).to be_valid
  end
end
