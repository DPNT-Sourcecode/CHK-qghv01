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

  def add_items(sku, number)
    items[sku] = 0 unless items.key?(sku)
    items[sku] += number
  end

  def claim_free_items(free_item_offers)
    free_items = earned_free_items(free_item_offers)

    free_items.each do |sku, qty|
      purchased = quantity_for sku
      items[sku] = [0, purchased - qty].max
    end
  end

  def claim_group_offers(group_offers)
    group_offers.each do |skus, batch_size|
      items_in_group = skus.chars.map { |sku| quantity_for sku }.sum
      batches = items_in_group / batch_size
      add_items(skus, batches)
      return if batches == 0

      skus.chars.each do |sku|
        break if items_in_group == 0
        being_batched = [items_in_group, quantity_for(sku)].min
        items_in_group -= being_batched
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





