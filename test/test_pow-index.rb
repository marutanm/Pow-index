require 'helper'
require 'rack/test'

class TestHoge < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    PowIndex::App
  end

  should "access to /" do
    get '/'
    assert last_response.ok?
  end
end
