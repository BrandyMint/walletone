# encoding: utf-8
# Сервис регистрации мерчанта
class W1::RegistrationService
  include W1::Requester
  ENDPOINT = 'registration/users'

  def initialize vendor
    @vendor = vendor
    @vendor_form = W1::RegistrationForm.build_from_object(@vendor)
  end

  def register
    response = post(ENDPOINT, @vendor_form)
    response_json = parse_response response

    case true
    when response_json.blank? || response.code.to_i == 404
      W1.error "Ошибка регистрации мерчанта [vendor_id=#{@vendor.id}]"
      raise VendorRegistrationError::W1Error.new(@vendor)
    when response_json['IsAlreadyRegistered'] == true
      W1.log "Дубликат мерчанта [vendor_id=#{@vendor.id}]"
      raise VendorRegistrationError::W1DuplicateMerchant.new(@vendor)
    when response.code.to_i == 201
      if @vendor.update_attributes! w1_merchant_id: response_json['UserId']
        W1.log "Мерчант зарегистрирован [vendor_id=#{@vendor.id}]"
      end
    end
    return true
  end
end
