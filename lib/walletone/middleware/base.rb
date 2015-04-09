require 'rack'
require 'walletone/notification'

# Это rack-middleware который принимает на себя
# первый удар с уведомлением от walletone
# Несет следующие обязанности:
#
# 1. Перевести параметры из cp1251 в unicode
# 2. Построить объект типа Noficiation
# 3. Вызвать метод perform с аргументами notify и env
#
# Метод peform должет быть переопределен в классах наследниках.
# Например Walletone::Middleware::Base
#
module Walletone::Middleware
  class Base
    OK = 'OK'
    RETRY = 'RETRY'

    def call(env)
      logger.info 'Middleware start'
      request  = Rack::Request.new env
      encoded_params = from_cp1251_to_utf8 request.params

      logger.info "Middleware parameters is #{encoded_params}"
      notify = Walletone::Notification.new encoded_params

      logger.info 'Middleware perform'
      ok_message = perform notify, env

      logger.info "Middleware result is #{ok_message}'"

      body = make_response OK, ok_message
      [200, {}, [body]]
    rescue => err
      Walletone.notify_error err

      [200, {}, [make_response(RETRY, err.message)]]
    end

    private

    def logger
      Walletone.logger
    end

    def perform notify, env
      raise 'Walletone middleware perform method is not implemented'
    end

    def make_response(result, description)
      # NOTE А нужно ли тут конвертировать в cp1251?
      if description
        "WMI_RESULT=#{result}&WMI_DESCRIPTION=#{description}"
      else
        "WMI_RESULT=#{result}"
      end
    end

    # walletone передает все параметры в cp1251
    # приводим в uft-8
    def from_cp1251_to_utf8(params)
      params.map do |k, v|
        [k, v.force_encoding("cp1251").encode("utf-8", undef: :replace)]
      end
    end
  end
end
