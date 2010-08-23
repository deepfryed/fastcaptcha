require_relative '../ext/fastcaptcha'
require 'digest/sha1'
class FastCaptcha
  CHARSET = ('A'..'Z').to_a + (0..9).to_a - [ 'I', 1, 'O', 0, 'G' ]

  def initialize cache=nil, level=1, w=200, h=50
    @cache  = cache || memcached_connection
    @level  = level
    @width  = w
    @height = h
  end

  def generate ttl=60, png=true, text=nil
    text = text || 6.times.map { CHARSET[rand(CHARSET.length)] }.join('')
    key = store(text, ttl)
    Challenge.new(key, png ? image(text, @level, @width, @height) : nil)
  end

  def store text, ttl
    key = Digest::SHA1.hexdigest("#{text}#{Time.now.to_s}")
    @cache.set key, text, ttl
    key
  end

  def refresh key
    text = @cache.get(key)
    text ? image(text, @level, @width, @height) : nil
  end

  def validate key, response
    rv = @cache.get(key) == response.upcase.strip
    @cache.delete(key) if rv
    rv
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
