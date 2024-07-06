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
    items = purchased_items(skus)

    free_items = earned_free_items(items)
    units_price = items
      .map { |sku, count| price_for_multiple(sku, count) }
      .sum

    units_price - free_items_discount(items, free_items)
  rescue NoSuchSkuError
    -1
  end

  private

  def purchased_items(skus)
    skus.chars.group_by { |sku| sku }.transform_values { |val| val.length }
  end

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

  def free_item_offers
    @free_item_offers || {
      'E' => [2, 'B']
    }
  end

  def earned_free_items(purchased_items)
    free_items = Hash.new(0)
    free_item_offers.each do |sku, offer|
      batch_size, free_item_sku = offer
      free_items[free_item_sku] += purchased_items.fetch(sku, 0) / batch_size
    end
    free_items
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
      discounted_items = [qty, purchased_items.fetch(sku, 0)].min
      price_for_multiple(sku, discounted_items)
    end.sum
  end
end





