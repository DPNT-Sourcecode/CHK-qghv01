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

  def checkout(skus)
    skus
      .chars
      .group_by { |sku| sku }
      .transform_values { |val| val.length }
      .map { |sku, count| price_for_multiple(sku, count) }
      .sum

  rescue NoSuchSkuError
    -1
  end

  private

  def price_for_multiple(item_sku, count)
    volume_discount = prices_with_volume_discounts[item_sku]

    return count * price_for_single(item_sku) if volume_discount.nil?

    batch_size, batch_price = volume_discount
    batches, units = count.divmod(batch_size)
    batch_price * batches + units * price_for_single(item_sku)
  end

  def price_for_single(item_sku)
    single_price_table.fetch(item_sku)
  rescue KeyError
    raise NoSuchSkuError
  end

  def prices_with_volume_discounts
    { 'A' => [3, 130], 'B' => [2, 45] }
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





