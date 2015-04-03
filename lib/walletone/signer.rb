require 'digest/sha1'
require 'digest/md5'

module Walletone
  class Signer
    def initialize(fields, hash_type = :md5)
      @fields = fields
      @hash_type = hash_type
    end
    
    def sign(secret_key = nil)
      values = @fields
        .reject { |k, v| k == 'WMI_SIGNATURE' }
        .sort { |x, y| x.first <=> y.first }
        .map(&:last).map(&:to_s)
      signature_string = [values, secret_key].flatten.compact.join
      encoded_signature_string = signature_string.encode('cp1251')

      case @hash_type
      when :md5
        Digest::MD5.base64digest(encoded_signature_string)
      when :sha1
        Digest::SHA1.base64digest(encoded_signature_string)
      else
        raise ArgumentError
      end
    end
  end
end
