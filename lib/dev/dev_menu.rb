# Developer tools. Add an entry with DevMenu.entry and it shows up automatically.
# `game` is nil when opened from the start menu; entries that need a game say so.
#
# Enable with:  ruby game.rb --dev
module DevMenu
  Entry = Struct.new(:label, :needs_game, :block)

  @entries = []

  class << self
    def entry(label, needs_game: true, &block)
      @entries << Entry.new(label, needs_game, block)
    end

    def run(game)
      loop do
        puts "\n--- DEV MENU ---"
        @entries.each_with_index { |e, i| puts "  #{i + 1}) #{e.label}" }
        puts "  0) Back"
        input = UI.read
        return if input == "0" || input.empty?

        e = @entries[input.to_i - 1]
        if e.nil?
          puts "Invalid choice."
        elsif e.needs_game && game.nil?
          puts "Start a game first."
        else
          e.block.call(game)
        end
      end
    end
  end

  entry("Validate world data", needs_game: false) do |_|
    problems = Registry.validate
    puts problems.empty? ? "OK: #{Registry.areas.size} areas, #{Registry.items.size} items." : problems
  end

  entry("List areas", needs_game: false) do |_|
    Registry.areas.each_value { |a| puts "#{a.id.to_s.ljust(24)} (#{a.region}) exits: #{a.exits.keys.join(', ')}" }
  end

  entry("Show player state") do |g|
    p = g.player
    puts "name=#{p.name} hp=#{p.hp}/#{p.max_hp} attack=#{p.base_attack} god=#{p.god_mode}"
    puts "location=#{p.location} inventory=#{p.inventory.inspect}"
    puts "flags=#{p.flags.inspect}"
  end

  entry("Teleport to area") do |g|
    id = UI.ask("Area id: ").to_sym
    if Registry.areas.key?(id)
      g.move_to(id)
      puts "Teleported."
    else
      puts "No such area."
    end
  end

  entry("Give item") do |g|
    id = UI.ask("Item id: ").to_sym
    Registry.items.key?(id) ? Inventory.add(g.player, id) && puts("Added.") : puts("No such item.")
  end

  entry("Set HP") do |g|
    g.player.hp = UI.ask("HP: ").to_i.clamp(0, g.player.max_hp)
  end

  entry("Set max HP / attack") do |g|
    g.player.max_hp = [UI.ask("Max HP: ").to_i, 1].max
    g.player.hp = [g.player.hp, g.player.max_hp].min
    g.player.base_attack = UI.ask("Base attack: ").to_i
  end

  entry("Toggle god mode") do |g|
    g.player.god_mode = !g.player.god_mode
    puts "God mode: #{g.player.god_mode}"
  end

  entry("Set flag") do |g|
    key = UI.ask("Flag name: ").to_sym
    val = UI.ask("Value (true/false/number/text): ")
    g.player.flags[key] = { "true" => true, "false" => false }.fetch(val) { val =~ /\A\d+\z/ ? val.to_i : val }
  end

  entry("Start a fight") do |g|
    id = UI.ask("Enemy id: ").to_sym
    Registry.enemies.key?(id) ? Combat.run(g, id) : puts("No such enemy.")
  end
end
