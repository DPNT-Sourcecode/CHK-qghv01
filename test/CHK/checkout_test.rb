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
      'E' => 40
    }
  end

  def test_single_sku
    single_price_table.each do |key, value|
      assert_equal value, sut.checkout(key), "Failed to fetch price for SKU #{key}"
    end
  end

  def test_invalid_input
    assert_equal (-1), sut.checkout('X')
  end

  def test_multiple_skus
    assert_equal 100, sut.checkout('ABC')
  end

  def test_multiple_with_one_invalid
    assert_equal (-1), sut.checkout('ABCX')
  end

  def test_with_special_offer
    assert_equal 130, sut.checkout('AAA')
  end

  def test_invalid_with_special_offer
    assert_equal (-1), sut.checkout('AAXA')
  end

  def test_with_multiple_special_offers
    assert_equal 240, sut.checkout('ABABACBB')
  end

  def test_second_special_offer
    assert_equal 200, sut.checkout('AAAAA')
  end

  def test_multiple_kinds_of_offers
    assert_equal 380, sut.checkout('AAAAAAAAA')
  end
end



