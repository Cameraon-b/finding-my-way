module Combat
  module_function

  # Runs a fight to the end. Returns :won, :fled or :died.
  def run(game, enemy_id)
    player = game.player
    enemy = Registry.enemy(enemy_id).spawn
    puts "\n#{enemy.intro}"

    loop do
      puts "\n#{enemy.name}: #{Health.bar(enemy.hp, enemy.max_hp)}"
      puts "#{player.name}: #{Health.bar(player.hp, player.max_hp)}"
      puts "Actions: attack, use <item>, flee"
      input = UI.read
      verb, arg = input.split(" ", 2)

      case verb
      when "attack", "a"
        dmg = player.base_attack + Inventory.attack_bonus(player) + rand(0..2)
        enemy.hp -= dmg
        puts "You hit the #{enemy.name} for #{dmg}."
      when "use"
        id = Inventory.find(player.inventory, arg) or (puts "You don't have that."; next)
        Actions.use_item(game, id)
      when "flee"
        if rand < 0.5
          puts "You escape!"
          return :fled
        end
        puts "You fail to get away!"
      else
        puts "Unknown combat action."
        next
      end

      if enemy.hp <= 0
        puts "\nThe #{enemy.name} is defeated."
        enemy.loot.each do |item_id|
          Inventory.add(player, item_id)
          puts "You find: #{Registry.item(item_id).name}"
        end
        return :won
      end

      hit = Health.damage(player, enemy.roll_damage)
      puts "The #{enemy.name} hits you for #{hit}."
      return :died if Health.dead?(player)
    end
  end
end
