class Walletone::Recurrent::Payment < Walletone::Payment
  define_fields %i(WMI_CUSTOMER_ID WMI_RECURRING_AGREEMENT_URL)

  def valid?
    super && self.WMI_CUSTOMER_ID && self.WMI_RECURRING_AGREEMENT_URL
  end
end
