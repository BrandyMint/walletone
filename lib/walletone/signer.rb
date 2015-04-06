require 'digest/sha1'
require 'digest/md5'

module Walletone
  class Signer
    def initialize(fields, hash_type = :md5)
      @fields = fields
      @hash_type = hash_type
    end
    
    def sign(secret_key = nil)
      values = prepare_values(@fields)
      string = make_signature_string(values, secret_key)

      make_digest(string, @hash_type)
    end

  private

    def prepare_values(fields)
      fields
        .reject { |k, v| k == 'WMI_SIGNATURE' }
        .sort { |x, y| x.first <=> y.first }
        .map(&:last).map(&:to_s)
    end

    def make_signature_string(values, secret_key)
      [values, secret_key].flatten.compact.join.encode('cp1251')
    end

    def make_digest(string, hash_type)
      case hash_type
      when :md5
        Digest::MD5.base64digest(string)
      when :sha1
        Digest::SHA1.base64digest(string)
      else
        raise ArgumentError
      end
    end
  end
end
