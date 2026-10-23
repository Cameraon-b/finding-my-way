#!/usr/bin/env ruby
# Entry point. Run with:  ruby game.rb [--dev]
GAME_TITLE = "FINDING MY WAY"
ROOT = __dir__

# Load order matters only for the engine; content files just register themselves.
%w[
  lib/core/ui lib/core/registry
  lib/systems/player lib/systems/health lib/systems/item lib/systems/inventory
  lib/systems/enemy lib/systems/combat
  lib/actions/actions
  world/area world/region
  lib/core/game
  lib/dev/dev_menu
  lib/screens/how_to_play lib/screens/opening lib/screens/start_menu
].each { |f| require File.join(ROOT, f) }

# Auto-load: any new file here is picked up with no other edits.
Dir[File.join(ROOT, "lib/actions/*.rb")].sort.each { |f| require f }
Dir[File.join(ROOT, "world/regions/**/*.rb")].sort.each { |f| require f }

dev = ARGV.include?("--dev")
UI.fast = dev

problems = Registry.validate
unless problems.empty?
  warn "World data problems:\n  #{problems.join("\n  ")}"
  exit 1
end

StartMenu.run(dev: dev)
player = Opening.run
Game.new(player, dev: dev).run
