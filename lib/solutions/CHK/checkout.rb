# noinspection RubyUnusedLocalVariable

require_relative 'shopping_cart'

class Checkout
  NoSuchSkuError = Class.new(StandardError)

  def initialize
    setup_offers
  end

  def checkout(skus)
    shopping_cart = ShoppingCart.from_str(skus)
    shopping_cart.claim_free_items(free_item_offers)

    shopping_cart
      .items
      .map { |sku, count| price_for_multiple(sku, count) }
      .sum
  rescue NoSuchSkuError
    -1
  end

  private

  def setup_offers
    group_id = group_products(['S', 'T', 'X', 'Y', 'Z'])

    volume_special_offer('A', 5, 200)
    volume_special_offer('A', 3, 130)
    volume_special_offer('B', 2, 45)
    volume_special_offer('F', 3, 20)
    volume_special_offer('H', 10, 80)
    volume_special_offer('H', 5, 45)
    volume_special_offer('K', 2, 150)
    volume_special_offer('P', 5, 200)
    volume_special_offer('Q', 3, 80)
    volume_special_offer('U', 4, 120)
    volume_special_offer('V', 3, 130)
    volume_special_offer('V', 2, 90)
    volume_special_offer(group_id, 3, 45)
    unit_price('A', 50)
    unit_price('B', 30)
    unit_price('C', 20)
    unit_price('D', 15)
    unit_price('E', 40)
    unit_price('F', 10)
    unit_price('G', 20)
    unit_price('H', 10)
    unit_price('I', 35)
    unit_price('J', 60)
    unit_price('K', 80)
    unit_price('L', 90)
    unit_price('M', 15)
    unit_price('N', 40)
    unit_price('O', 10)
    unit_price('P', 50)
    unit_price('Q', 30)
    unit_price('R', 50)
    unit_price('S', 30)
    unit_price('T', 20)
    unit_price('U', 40)
    unit_price('V', 50)
    unit_price('W', 20)
    unit_price('X', 90)
    unit_price('Y', 10)
    unit_price('Z', 50)
  end

  def group_products(skus)
    group_id = skus.to_s
    product_groups[group_id] = skus
    group_id
  end

  # returns the first group_id that contains sku
  def group_for(sku)
    matches = product_groups
      .filter { |group_id, skus| skus.include? sku }

    return sku if matches.empty?
    matches.entries.first[0]
  end

  def product_groups
    @product_groups ||= {}
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

  def available_offers(group_id)
    volume_offers.fetch(group_id)
  rescue KeyError
    raise NoSuchSkuError
  end

  def volume_offers
    @volume_offers ||= {}
  end

  def free_item_offers
    @free_item_offers || {
      'E' => [2, 'B'],
      'N' => [3, 'M'],
      'R' => [3, 'Q'],
    }
  end

  def earned_free_items(shopping_cart)
    free_items = Hash.new(0)
    free_item_offers.each do |sku, offer|
      batch_size, free_item_sku = offer
      free_items[free_item_sku] += shopping_cart.quantity_for(sku) / batch_size
    end
    free_items
  end

  def unit_price(sku, price)
    volume_special_offer(sku, 1, price)
  end

  # TODO: sort volume_offers automatically after inserting
  def volume_special_offer(group_id, batch_size, price)
    volume_offers[group_id] = [] unless volume_offers.include?(group_id)
    volume_offers[group_id] << [batch_size, price]
  end
end









