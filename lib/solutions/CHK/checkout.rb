# noinspection RubyUnusedLocalVariable
class Checkout
  NoSuchSkuError = Class.new(StandardError)

  # +------+-------+------------------------+
  # | Item | Price | Special offers         |
  # +------+-------+------------------------+
  # | A    | 50    | 3A for 130, 5A for 200 |
  # | B    | 30    | 2B for 45              |
  # | C    | 20    |                        |
  # | D    | 15    |                        |
  # | E    | 40    | 2E get one B free      |
  # +------+-------+------------------------+

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
    offers = prices_with_volume_discounts.fetch(item_sku)

    sum = 0
    offers.each do |offer|
      batch_size, batch_price = offer
      batches = count / batch_size
      sum += batch_price * batches
      count -= batches * batch_size
    end
    sum
  rescue KeyError
    raise NoSuchSkuError
  end

  def price_for_single(item_sku)
    single_price_table.fetch(item_sku)
  rescue KeyError
    raise NoSuchSkuError
  end

  def prices_with_volume_discounts
    {
      'A' => [[5, 200], [3, 130], unit_price(50)],
      'B' => [[2, 45], unit_price(30)],
      'C' => [unit_price(20)],
      'D' => [unit_price(15)],
      'E' => [unit_price(40)]
    }
  end

  def offers
    @offers ||= {}
  end

  def unit_price(sku, price)
    unless offers.include? sku
      offers[sku] = []
    end
    offers[sku] << [1, price]
  end
end




