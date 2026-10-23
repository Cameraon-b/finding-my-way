# Item definitions. Register new ones anywhere with Item.define.
#
#   Item.define :healing_herb, name: "Healing Herb", description: "...",
#               on_use: ->(game) { ... }   # optional; return false to keep the item
#               attack_bonus: 2            # optional passive bonus while carried
class Item
  attr_reader :id, :name, :description, :on_use, :attack_bonus

  def self.define(id, name:, description: "", on_use: nil, attack_bonus: 0)
    Registry.items[id] = new(id, name, description, on_use, attack_bonus)
  end

  def initialize(id, name, description, on_use, attack_bonus)
    @id = id
    @name = name
    @description = description
    @on_use = on_use
    @attack_bonus = attack_bonus
  end

  def usable? = !@on_use.nil?
end
