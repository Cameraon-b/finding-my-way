# One "screen" of the game. Define areas with a small DSL:
#
#   Area.define :woods_cabin do
#     in_region :whispering_woods
#     title "Abandoned Cabin"
#     describe "A cabin sits here."          # or describe { |game| "dynamic text" }
#     exit_to "south", :woods_clearing
#     has_item :rusty_key
#     encounter :wolf                         # fights once, on first entry
#     on_enter { |game, first_visit| ... }
#     action("search") { |game, args| ... }   # area-specific commands
#   end
class Area
  attr_reader :id, :region, :exits, :items, :encounter, :title

  def self.define(id, &block)
    area = new(id)
    area.instance_eval(&block)
    Registry.areas[id] = area
  end

  def initialize(id)
    @id = id
    @exits = {}
    @items = []
    @actions = {}
    @description = ""
  end

  # --- DSL ---
  def in_region(id)          = @region = id
  def title(text = nil)      = text ? @title = text : @title
  def describe(text = nil, &block) = @description = block || text
  def exit_to(dir, area_id)  = @exits[dir] = area_id
  def has_item(id)           = @items << id
  def encounter(id = nil)    = id ? @encounter = id : @encounter
  def on_enter(&block)       = @on_enter = block
  def action(verb, &block)   = @actions[verb] = block

  # --- Runtime ---
  def description_for(game)
    @description.respond_to?(:call) ? @description.call(game) : @description
  end

  def enter(game, first_visit)
    @on_enter&.call(game, first_visit)
    return unless @encounter && first_visit

    result = Combat.run(game, @encounter)
    UI.pause
    # A fled fight can be retried next time you come back.
    game.player.flags[:"fled_#{id}"] = true if result == :fled
  end

  def run_action(game, input)
    verb, args = input.split(" ", 2)
    block = @actions[verb] or return false
    block.call(game, args.to_s)
    true
  end
end
