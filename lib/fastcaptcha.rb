require_relative '../ext/fastcaptcha'
require 'digest/sha1'
require 'moneta'

class FastCaptcha
  CHARSET = ('A'..'Z').to_a + (0..9).to_a - ['I', 1, 'O', 0, 'G']

  attr_reader :cache

  def initialize cache = nil, level = 1, w = 200, h = 50
    @cache  = cache || cache_connection
    @level  = level
    @width  = w
    @height = h
  end

  def generate ttl = 60, png = true, text = nil
    text = text || 6.times.map { CHARSET[rand(CHARSET.length)] }.join('')
    key  = store(text.strip.upcase, ttl)
    Challenge.new(key, png ? image(text, @level, @width, @height) : nil)
  end

  def hash text
    'fastcaptcha:%s' % Digest::SHA1.hexdigest("#{text}#{Time.now.to_f}")
  end

  def store text, ttl
    key = hash(text)
    cache.store(key, text, expires_in: ttl)
    key
  end

  def refresh key
    text = cache[key]
    text ? image(text, @level, @width, @height) : nil
  end

  def validate key, response
    rv = response && (cache[key] == response.upcase.strip)
    rv && cache.delete(key)
  end

  def cache_connection
    require 'moneta/redis2'
    Moneta::Redis2.new
  end

  class Challenge
    attr_reader :key, :image
    def initialize key, image
      @key, @image = key, image
    end
  end
end
