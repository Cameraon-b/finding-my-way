# finding-my-way

Text adventure in Ruby. Run: `ruby game.rb` (add `--dev` for the dev menu and instant text).

## Adding content
- **Region:** new folder in `world/regions/<name>/` with a `region.rb` (`Region.define`, items, enemies) and one file per area (`Area.define`). Files are auto-loaded.
- **Command:** drop a file in `lib/actions/` and call `Actions.register`.
- **Dev menu entry:** `DevMenu.entry` in `lib/dev/dev_menu.rb`.
- Areas link by id, so regions can connect with `exit_to "north", :other_region_area`. Dev menu -> "Validate world data" catches broken links (also checked at startup).
