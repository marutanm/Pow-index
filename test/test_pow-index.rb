require 'helper'
require 'rack/test'

class TestHoge < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    PowIndex::App
  end

  context '#to_i' do
    should "access to /" do
      get '/'
      assert last_response.ok?
    end
  end
end
