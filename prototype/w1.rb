module W1

  API_URL      = 'https://api.w1.ru/OpenApi/'
  # новый url
  WEB_CHECKOUT_URL = 'https://wl.walletone.com/checkout/checkout/Index'
  ## Старый URL
  #WEB_CHECKOUT_URL = 'https://www.walletone.com/checkout/default.aspx'
  API_CHECKOUT_URL = 'https://www.walletone.com/checkout/default.aspx'

  WMI_SIGNATURE   = 'WMI_SIGNATURE'
  WMI_PAYMENT_NO  = 'WMI_PAYMENT_NO'
  WMI_ORDER_STATE = 'WMI_ORDER_STATE'

  extend LoggerConcern
  self.log_tag = :W1

  def self.generate_signtature_from_options options, md5_secret_key
    generate_signtature_from_list options.to_a, md5_secret_key
  end

  def self.generate_signtature_from_list list, md5_secret_key
    values = list.
      reject { |e| e.first==WMI_SIGNATURE }.
      sort { |x,y| x.first<=>y.first }.map &:last
    signature_string = [values, md5_secret_key].flatten.join
    encoded_signature_string = signature_string.encode("cp1251")
    Digest::MD5.base64digest(encoded_signature_string)
  end
end
