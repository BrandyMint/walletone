require 'walletone/recurrent'
require 'walletone/recurrent/invoice'
require 'walletone/recurrent/client'

describe Walletone::Recurrent::Client do
  let(:merchant_id) { 127_830_694_690 }
  let(:secret_key) { '3475706857624f46344e573753316e387c396e5f4b54767b796c4c' }
  let(:customer_id) { 123 }

  let(:client) { Walletone::Recurrent::Client.new merchant_id: merchant_id, secret_key: secret_key, customer_id: customer_id }

  let(:fields) do
    Walletone::Fields.new WMI_PAYMENT_AMOUNT: 123, WMI_MERCHANT_ID: merchant_id, WMI_CUSTOMER_ID: 123, WMI_RECURRING_AGREEMENT_URL: 'http://'
  end

  let(:invoice) { Walletone::Recurrent::Invoice.new Amount: 123, OrderId: 456 }

  context '#create_invoice' do
    let(:result) do
      { 'Invoice' => { 'InvoiceId' => 345_539_868_062,
                       'Amount' => 1.24,
                       'CurrencyId' => 643,
                       'InvoiceStateId' => 'Created',
                       'CreateDate' => '2015-12-31T08:20:13',
                       'UpdateDate' => '2015-12-31T08:20:13',
                       'Payment' => { 'PaymentId' => 69_904_496,
                                      'PaymentCode' => '345539868062',
                                      'PaymentCodeType' => 'InvoiceId',
                                      'CreateDate' => '2015-12-31T08:20:14.137',
                                      'UpdateDate' => '2015-12-31T08:20:14.137',
                                      'PaymentStateId' => 'Created',
                                      'PaymentTypeId' => 'CreditCardRUB' } },
        'CanSaveAsExternalAccount' => true }
    end
    before do
      stub_request(:post, 'https://wl.walletone.com/checkout/invoicingapi/invoices')
        .with(body: "{\"OrderId\":456,\"Amount\":123,\"CurrencyId\":643,\"PaymentTypeId\":\"CreditCardRUB\",\"InvoiceAdditionalParams\":{}}")
        .to_return(status: 200, body: result.to_json, headers: { 'Content-Type' => 'application/json; charset=utf-8' })
    end
    it do
      res = client.create_invoice invoice
      expect(res).to be_a Walletone::Recurrent::ResultInvoice
    end
  end

  context '#make_payment' do
    let(:payment_id) { 123 }
    let(:result) { {} }
    before do
      stub_request(:post, 'https://wl.walletone.com/checkout/invoicingapi/payments/123/process')
        .with(body: "{\"CustomerId\":\"123\",\"CreditCardTerminal\":\"Non3Ds\",\"UseSavedAuthData\":\"true\",\"AuthData\":{\"RecurrentCreditCardEmail\":\"some@email.ru\"}}")
        .to_return(status: 200, body: result.to_json, headers: { 'Content-Type' => 'application/json; charset=utf-8' })
    end
    pending 'ответ'
    # it do
    # res = client.make_payment payment_id: payment_id, email: 'some@email.ru'
    # expect(res).to eq 'aaa'
    # end
  end
end
