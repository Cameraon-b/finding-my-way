Actions.register("look", aliases: %w[l], help: "Describe your surroundings") do |game, _|
  game.describe_area = true
end

Actions.register("inventory", aliases: %w[i inv], help: "List what you carry") do |game, _|
  items = Inventory.items(game.player)
  if items.empty?
    puts "You carry nothing."
  else
    puts "You carry:"
    items.each { |it| puts "  - #{it.name}: #{it.description}" }
  end
  UI.pause
end

Actions.register("take", aliases: %w[get grab], help: "take <item>") do |game, args|
  here = game.items_here
  id = Inventory.find(here, args)
  if id.nil?
    puts args.empty? ? "Take what?" : "You don't see that here."
  else
    here.delete_at(here.index(id))
    Inventory.add(game.player, id)
    puts "You take the #{Registry.item(id).name}."
    UI.pause
  end
end

Actions.register("use", help: "use <item>") do |game, args|
  id = Inventory.find(game.player.inventory, args)
  if id.nil?
    puts args.empty? ? "Use what?" : "You don't have that."
  else
    Actions.use_item(game, id)
  end
  UI.pause
end

Actions.register("stats", aliases: %w[status], help: "Show health and attack") do |game, _|
  p = game.player
  puts "#{p.name}"
  puts "HP: #{Health.bar(p.hp, p.max_hp)}"
  puts "Attack: #{p.base_attack + Inventory.attack_bonus(p)}"
  UI.pause
end

Actions.register("help", aliases: %w[?], help: "List commands") do |game, _|
  puts "Commands:"
  Actions.commands.each_value do |c|
    next if c.dev_only && !game.dev

    puts "  #{c.name.ljust(10)} #{c.help}"
  end
  puts "  #{'<exit>'.ljust(10)} Move in a listed direction (or 'go <exit>')"
  UI.pause
end

Actions.register("quit", aliases: %w[exit], help: "Leave the game") do |game, _|
  puts "Thanks for playing, #{game.player.name}!"
  game.running = false
end

Actions.register("dev", help: "Open the developer menu", dev_only: true) do |game, _|
  DevMenu.run(game)
end
