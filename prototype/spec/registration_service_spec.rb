require 'rails_helper'

describe W1::RegistrationService do
  before do
    stub_request(:any, /#{Regexp.quote(URI.parse(W1::API_URL).host)}/).to_rack(W1ApiMock.new)
  end

  let(:personal_vendor) { create :vendor, :personal }
  let(:business_vendor) { create :vendor, :business }
  let(:duplicate_vendor) { create :vendor, phone: '+77777777777' }

  subject { W1::RegistrationService }
  # before { allow_any_instance_of(Vendor).to receive(:phone).and_return('support@kiiiosk.ru') }

  describe 'Register W1 merchant w/' do
    context 'personal' do
      it 'should register personal merchant' do
        subject.new(personal_vendor).register
        expect(personal_vendor.reload.w1_merchant_id).to eq('Personal')
      end
    end

    context 'business' do
      it 'should register business merchant' do
        subject.new(business_vendor).register
        expect(business_vendor.reload.w1_merchant_id).to eq('Business')
      end
    end

    context 'duplicate' do
      it 'should return duplication error' do
        expect{
          subject.new(duplicate_vendor).register
        }.to raise_error(VendorRegistrationError::W1DuplicateMerchant)
      end
    end

    context 'empty' do
      it 'should return error' do
        expect{
          subject.new(Vendor.new).register
        }.to raise_error(VendorRegistrationError::W1Error)
      end
    end
  end
end
