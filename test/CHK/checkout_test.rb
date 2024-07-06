# noinspection RubyResolve,RubyResolve
require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'CHK'

class ClientTest < Minitest::Test
  def sut
    Checkout.new
  end

  def test_single_sku
    assert_equal sut.checkout('A'), 50
  end

  def test_another_sku
    assert_equal sut.checkout('C'), 20
  end
end

