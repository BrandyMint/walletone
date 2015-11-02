require 'digest/sha1'
require 'digest/md5'

require 'walletone/fields'

module Walletone
  class Signer
    include Virtus.model strict: true, coerce: false
    SIGN_HASH_TYPES   = [:md5, :sha1]
    DEFAULT_HASH_TYPE = :md5
    WMI_SIGNATURE     = 'WMI_SIGNATURE'

    attribute :fields,     Walletone::Fields, requried: true

    def self.sign(content, hash_type)
      case hash_type
      when :md5
        Digest::MD5.base64digest content
      when :sha1
        Digest::SHA1.base64digest content
      else
        raise ArgumentError, hash_type
      end
    end

    def signature secret_key, hash_type=DEFAULT_HASH_TYPE
      self.class.sign fields_as_string( secret_key ), hash_type
    end

    private

    def fields_as_string secret_key
      [sorted_values, secret_key].join.encode('cp1251')
    end

    # Удаляем подпись и сортируем поля в алфавитном порядке
    #
    def sorted_values
      fields
        .as_list
        .reject { |f| f.first == WMI_SIGNATURE }
        .sort { |a, b|  [ a[0], a[1] ] <=> [ b[0], b[1] ] }
        .map(&:last)
        .map(&:to_s)
        .compact
    end

  end
end
