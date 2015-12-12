require 'walletone/recurrent'
require 'walletone/recurrent/invoice'
require 'walletone/recurrent/client'

describe Walletone::Recurrent::Client do
  let(:merchant_id) { 127830694690 }
  let(:secret_key) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }
  let(:customer_id) { 123 }

  let(:client) { Walletone::Recurrent::Client.new merchant_id: merchant_id, secret_key: secret_key, customer_id: customer_id }

  let(:fields) do
    Walletone::Fields.new WMI_PAYMENT_AMOUNT: 123, WMI_MERCHANT_ID: merchant_id, WMI_CUSTOMER_ID: 123, WMI_RECURRING_AGREEMENT_URL: 'http://'
  end

  let(:invoice) { Walletone::Recurrent::Invoice.new Amount: 123, OrderId: 456 }

  context '#create_invoice' do
    it do
      res = client.create_invoice invoice
      expect(res).to eq 'aaa'
    end
  end

  context '#make_payment' do
    let(:payment_id) { 123 }
    it do
      res = client.make_payment payment_id
      expect(res).to eq 'aaa'
    end
  end
end
