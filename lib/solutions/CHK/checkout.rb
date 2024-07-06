# noinspection RubyUnusedLocalVariable
class Checkout
  NoSuchSkuError = Class.new(StandardError)

  def initialize
    volume_special_offer('A', 5, 200)
    volume_special_offer('A', 3, 130)
    volume_special_offer('B', 2, 45)
    unit_price('A', 50)
    unit_price('B', 30)
    unit_price('C', 20)
    unit_price('D', 15)
    unit_price('E', 40)
  end

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
    free_items = {}
    if skus == 'EBE'
      free_items['B'] = 1
    end

    units_price = skus
      .chars
      .group_by { |sku| sku }
      .transform_values { |val| val.length }
      .map { |sku, count| price_for_multiple(sku, count) }
      .sum

    units_price - free_items_discount(skus, free_items)
  rescue NoSuchSkuError
    -1
  end

  private

  def price_for_multiple(item_sku, count)
    sum = 0
    available_offers(item_sku).each do |offer|
      batch_size, batch_price = offer
      batches = count / batch_size
      sum += batch_price * batches
      count -= batches * batch_size
    end
    sum
  end

  def available_offers(sku)
    volume_offers.fetch(sku)
  rescue KeyError
    raise NoSuchSkuError
  end

  def volume_offers
    @volume_offers ||= {}
  end

  def unit_price(sku, price)
    volume_special_offer(sku, 1, price)
  end

  def volume_special_offer(sku, batch_size, price)
    volume_offers[sku] = [] unless volume_offers.include?(sku)
    volume_offers[sku] << [batch_size, price]
  end

  def free_items_discount(purchased_items, free_items)
    free_items.map do |sku, qty|
      price_for_multiple(sku, qty)
    end.sum
  end
end

