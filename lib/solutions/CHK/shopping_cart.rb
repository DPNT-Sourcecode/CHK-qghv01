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

  def claim_group_offers(group_offers)
    group_offers.each do |skus, offer|
      items_in_group = skus.chars.map { |sku| quantity_for sku }.sum
      batch_size, _ = offer
      to_be_batched = items_in_group / batch_size
      skus.chars.each do |sku|
        break if to_be_batched == 0
        being_batched = [to_be_batched, quantity_for(sku)].min
        to_be_batched -= being_batched
        items[sku] -= being_batched
      end
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

