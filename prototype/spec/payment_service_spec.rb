require 'rails_helper'

describe W1::PaymentService do
  let(:vendor) { create :vendor, w1_md5_secret_key: "623577687055676e43446f6c474f385165356e64556e474e5d7366" }

  subject { described_class.new vendor: vendor, params: params }

  #context 'просто плохие данные' do
    #let(:params) { {a: 'failed params'} }

    #it 'должен выдать ответ с повтором' do
      #expect(W1).to receive(:error)
      #expect(subject.perform_and_get_response).to include 'RETRY'
    #end
  #end

  context 'удачный платеж' do
    let(:order)  { create :order, vendor: vendor }

    # Эти параметры бесполезно менять, потому что они подписаны
    # сигнатурой
    #
    let(:params) {
      {
        "WMI_AUTO_ACCEPT" => "1",
        "WMI_COMMISSION_AMOUNT" => "48.00",
        "WMI_CREATE_DATE" => "2014-11-17 10:57:19",
        "WMI_CURRENCY_ID" => "643",
        "WMI_DELIVERY_ADDRESS" => "Павелецкая пл. д. 3 стр. 2, м. Павелецкая",
        "WMI_DELIVERY_CITY" => "Москва",
        "WMI_DELIVERY_COMMENTS" => "Прошу осуществить доставку до среды (19 ноября), спаисбо",
        "WMI_DELIVERY_CONTACTINFO" => "+79262943610",
        "WMI_DELIVERY_COST" => "200.00",
        "WMI_DELIVERY_COUNTRY" => "Россия",
        "WMI_DELIVERY_DATEFINISHED" => "2014-11-18 14:18:46",
        "WMI_DELIVERY_ORDERID" => "538",
        "WMI_DELIVERY_REQUIRED" => "true",
        "WMI_DELIVERY_SKIPINSTRUCTION" => "1",
        "WMI_DELIVERY_STATE" => "Delivered",
        "WMI_DESCRIPTION" => "Браслет-нить Бесконечность",
        "WMI_EXPIRED_DATE" => "2015-02-17 10:57:19",
        "WMI_EXTERNAL_ACCOUNT_ID" => "127696943127:538",
        "WMI_FAIL_URL" => "http://wannabe.kiiiosk.ru/payments/w1/failure",
        "WMI_LAST_NOTIFY_DATE" => "2014-11-20 15:25:38",
        "WMI_MERCHANT_ID" => "127696943127",
        "WMI_NOTIFY_COUNT" => "34",
        "WMI_ORDER_ID" => "347571000181",
        "WMI_ORDER_STATE" => "Accepted",
        "WMI_ORIGINAL_AMOUNT" => "1300.00",
        "WMI_PAYMENT_AMOUNT" => "1200.00",
        "WMI_PAYMENT_NO" => "538",
        "WMI_SUCCESS_URL" => "http://wannabe.kiiiosk.ru/payments/w1/success",
        "WMI_UPDATE_DATE" => "2014-11-20 08:14:58",
        "WMI_SIGNATURE" => "aLhAMo4+eYyleQS88xmWyQ==",
      }

    }

    it 'должен выдать ответ с повтором' do
      expect(W1).to receive(:info)
      orders = double
      expect(orders).to receive(:find_by_wmi_payment_no).with('538').and_return order
      expect(vendor).to receive(:orders).and_return orders
      expect(subject.perform_and_get_response).to include 'WMI_RESULT=OK'

      expect(order.order_payment.state).to eq OrderPayment::STATE_PAID
      expect(order.state).to eq OrderStates::STATE_ACCEPTED
    end

  end

end
