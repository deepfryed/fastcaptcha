require 'redis'
require 'moneta/redis'

module Moneta
  class Redis2 < Redis
    def key? key
      @cache.exists(key)
    end

    def store key, value, options = {}
      if options.key?(:expires_in)
        @cache.setex(key, options[:expires_in], value)
      else
        @cache.set(key, value)
      end
    end

    def delete key
      value = @cache[key]
      @cache.del(key) if value
      value
    end
  end
end
