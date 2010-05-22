require_relative '../ext/fastcaptcha'
require 'digest/sha1'
class FastCaptcha
  CHARSET = ('A'..'Z').to_a + (0..9).to_a - [ 'I', 1, 'O', 0 ]

  def initialize cache=nil, level=1
    @cache = cache || memcached_connection
    @level = level
  end

  def generate ttl=60, png=true, text=nil
    text = text || 6.times.map { CHARSET[rand(CHARSET.length)] }.join('')
    key = store(text, ttl)
    Challenge.new(key, png ? image(text, @level) : nil)
  end

  def store text, ttl
    key = Digest::SHA1.hexdigest("#{text}#{Time.now.to_s}")
    @cache.set key, text, ttl
    key
  end

  def refresh key
    text = @cache.get(key)
    text ? image(text, @level) : nil
  end

  def validate key, response
    @cache.get(key) == response
  end

  def memcached_connection
    require 'cache/memcached'
    Cache::Memcached.instance
  end

  class Challenge
    attr_reader :key, :image
    def initialize key, image
      @key, @image = key, image
    end
  end
end
