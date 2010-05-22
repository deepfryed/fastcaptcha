require 'helper'

describe 'FastCaptcha' do
  before do
    @captcha = FastCaptcha.new
    @challenge = @captcha.generate 1, true, 'barfoo'
  end
  it 'should generate a png image given a text string' do
    assert_equal @challenge.key.length, 40
    assert_equal @challenge.image[0..3], "\x89PNG"
  end
  it 'should validate given correct key' do
    assert @captcha.validate(@challenge.key, 'barfoo')
  end
  it 'should not validate given incorrect key' do
    assert !@captcha.validate(@challenge.key, 'foobar')
  end
  it 'should fail to validate after ttl' do
    sleep 1
    assert !@captcha.validate(@challenge.key, 'barfoo')
  end
end
