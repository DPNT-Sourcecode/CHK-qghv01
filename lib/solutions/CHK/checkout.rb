# noinspection RubyUnusedLocalVariable
class Checkout
  NoSuchSkuError = Class.new(StandardError)

  # Our price table and offers:
  # +------+-------+----------------+
  # | Item | Price | Special offers |
  # +------+-------+----------------+
  # | A    | 50    | 3A for 130     |
  # | B    | 30    | 2B for 45      |
  # | C    | 20    |                |
  # | D    | 15    |                |
  # +------+-------+----------------+
  # Invalid input: return -1

  def checkout(skus)
    sum = 0
    single_price_table.each do |sku, price|
      number_items = skus.count sku
      sum += number_items * price
    end

    sum
  rescue NoSuchSkuError
    -1
  end

  private

  def price_for(item_sku)
    single_price_table.fetch(item_sku)
  rescue KeyError
    raise NoSuchSkuError
  end

  def single_price_table
    {
      'A' => 50,
      'B' => 30,
      'C' => 20,
      'D' => 15,
    }
  end
end






