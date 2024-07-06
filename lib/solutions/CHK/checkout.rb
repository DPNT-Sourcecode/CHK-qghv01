# noinspection RubyUnusedLocalVariable
class Checkout
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
    skus.inject { |sku| }
    price_for skus
  end

  private

  def price_for(item_sku)
    single_price_table[item_sku] || -1
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



