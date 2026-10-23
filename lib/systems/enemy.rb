#   Enemy.define :wolf, name: "Grey Wolf", hp: 10, damage: 2..4, intro: "A wolf growls."
class Enemy
  attr_reader :id, :name, :max_hp, :damage, :intro, :loot
  attr_accessor :hp

  def self.define(id, name:, hp:, damage:, intro: nil, loot: [])
    Registry.enemies[id] = new(id, name, hp, damage, intro, loot)
  end

  def initialize(id, name, hp, damage, intro, loot)
    @id = id
    @name = name
    @max_hp = hp
    @damage = damage # Integer or Range
    @intro = intro || "A #{name} blocks your way!"
    @loot = loot
  end

  # Combat works on a fresh copy so the definition is never mutated.
  def spawn
    copy = dup
    copy.hp = @max_hp
    copy
  end

  def roll_damage = @damage.is_a?(Range) ? rand(@damage) : @damage
end
