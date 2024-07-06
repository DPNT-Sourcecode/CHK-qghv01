# noinspection RubyResolve,RubyResolve
require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'CHK'

class ClientTest < Minitest::Test
  def sut
    Checkout.new
  end

  def single_price_table
    {
      'A' => 50,
      'B' => 30,
      'C' => 20,
      'D' => 15,
    }
  end

  def test_single_sku
    single_price_table.each do |key, value|
      assert_equal value, sut.checkout(key)
    end
  end

  def test_invalid_input
    assert_equal sut.checkout('X'), -1
  end
end


