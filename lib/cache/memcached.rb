require 'memcached'
require 'logger'
module Cache
  class Memcached
    @@instance

    def self.instance
      @@instance ||= self.new("localhost:11211")
    end

    def initialize *args
      @args   = args
      @cache  = ::Memcached.new(*args)
      @logger = Logger.new($stdout, 0)
    end

    def set key, value, ttl=0, marshall=true
      op(:set, key, value, ttl, marshall)
    end

    def delete key
      op(:delete, key)
    end

    def get key
      op(:get, key)
    end

    def flush
      op(:flush)
    end

    private
    def op action, *args
      tries = 0
      begin
        @cache.send(action, *args)
      rescue ::Memcached::ServerIsMarkedDead => e
        tries += 1
        reconnect
        @logger.warn("server dead: #{e} failed #{action}, reconnecting ...")
        retry if tries < 2
        nil
      rescue ::Memcached::NotFound
      end
    end

    def reconnect
      @cache = ::Memcached.new(*@args)
    end
  end
end
