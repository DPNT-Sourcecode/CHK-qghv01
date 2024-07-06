class ShoppingCart
  attr_reader :items

  def self.from_str(skus)
    items = skus.chars.group_by { |sku| sku }.transform_values { |val| val.length }
    new(items)
  end

  def initialize(items)
    @items = items
  end

  def quantity_for(sku)
    items.fetch(sku, 0)
  end

  def claim_free_items(free_item_offers)
    free_items = earned_free_items(free_item_offers)

    free_items.each do |sku, qty|
      purchased = quantity_for sku
      items[sku] = [0, purchased - qty].max
    end
  end

  private

  attr_writer :items

  def earned_free_items(offers)
    free_items = Hash.new(0)
    offers.each do |sku, offer|
      batch_size, free_item_sku = offer
      free_items[free_item_sku] += quantity_for(sku) / batch_size
    end
    free_items
  end
end
