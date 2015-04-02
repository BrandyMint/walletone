describe Walletone::Payment do
  context '.initialize' do
    it 'works' do
      payment = described_class.new(merchant_id: 123)
      expect(payment.merchant_id).to eq(123)
    end
  end

  context '#build_form' do
    it 'builds form' do
      payment = Fabricate(:payment, merchant_id: 127830694690)
      form = payment.build_form
      expect(form).to be_a(Walletone::Form)
      expect(form.fields).to include(['WMI_MERCHANT_ID', 127830694690])
    end
  end
end
