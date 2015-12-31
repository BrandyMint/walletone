require 'walletone/invoicing'

describe Walletone::Invoicing::Client do
  let(:user_id) { 127830694600 }
  let(:secret_key) { 'abc' }
  let(:amount) { Money.new 1000, 'rub' }
  let(:order_id) { '123' }

  let(:success_response) { '{"Invoice":{"InvoiceId":123,"Amount":10.0000,"CurrencyId":643,"InvoiceStateId":"Created","CreateDate":"2015-11-02T08:11:57","UpdateDate":"2015-11-02T08:11:57","Payment":{"PaymentId":123,"Amount":10.0000,"CurrencyId":643,"PaymentCode":"123","PaymentCodeType":"InvoiceId","CreateDate":"2015-11-02T08:11:57","UpdateDate":"2015-11-02T08:11:57","PaymentStateId":"Created","PaymentTypeId":"MtsRUB","ExternalAccountId":null}},"CanSaveAsExternalAccount":false}' }

  subject { Walletone::Invoicing::Client.new user_id: user_id, secret_key: secret_key }

  let(:invoice) { Walletone::Recurrent::Invoice.new Amount: amount, OrderId: order_id }

  context '#make_invoice' do
    it do
      stub_request(:post, Walletone::Invoicing::Client::BASE_URL + 'invoices').to_return(body: success_response)
      expect(subject.make_invoice(invoice)).to be_a(Hash)
    end
  end
end
