# All mutable game state for the hero. Keep it plain data so it can be saved later.
class Player
  attr_accessor :name, :hp, :max_hp, :base_attack, :location, :inventory, :flags, :god_mode

  def initialize(name)
    @name = name
    @max_hp = 20
    @hp = @max_hp
    @base_attack = 3
    @location = nil
    @inventory = []   # item ids
    @flags = {}       # story flags, e.g. flags[:met_hermit] = true
    @god_mode = false
  end
end
