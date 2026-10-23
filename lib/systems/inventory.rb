module Inventory
  module_function

  def add(player, item_id)
    Registry.item(item_id) # raises on typos
    player.inventory << item_id
  end

  def remove(player, item_id)
    idx = player.inventory.index(item_id) or return false
    player.inventory.delete_at(idx)
    true
  end

  def has?(player, item_id) = player.inventory.include?(item_id)

  def items(player) = player.inventory.map { |id| Registry.item(id) }

  # Finds an item in the inventory (or a list of ids) by id or partial name.
  def find(ids, query)
    q = query.to_s.downcase.tr(" ", "_")
    ids.find { |id| id.to_s == q } ||
      ids.find { |id| Registry.item(id).name.downcase.include?(query.to_s.downcase) }
  end

  def attack_bonus(player) = items(player).sum(&:attack_bonus)
end
