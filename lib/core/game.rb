# Owns the running session: the player, the current area and the main loop.
class Game
  attr_reader :player
  attr_accessor :running, :dev, :describe_area

  def initialize(player, dev: false)
    @player = player
    @dev = dev
    @running = true
    @describe_area = true
    @area_items = {}   # area id => items still lying there
    @visited = {}
    @player.location ||= Registry.start_area
  end

  def area = Registry.area(@player.location)

  # Items still on the ground in the current area (lazily seeded from the area definition).
  def items_here = (@area_items[area.id] ||= area.items.dup)

  def move_to(area_id)
    @player.location = area_id
    @describe_area = true
  end

  def run
    while @running
      enter_area if @describe_area
      break unless @running

      show_area
      handle(UI.read)
      return game_over if Health.dead?(@player)
    end
  end

  private

  def enter_area
    first_visit = !@visited[area.id]
    @visited[area.id] = true
    area.enter(self, first_visit)
    return unless Health.dead?(@player)

    game_over
  end

  def show_area
    @describe_area = false
    UI.clear
    region = Registry.regions[area.region]
    puts "[#{region ? region.name : '???'}] #{area.title}\n\n" if area.title
    puts area.description_for(self)
    items = items_here
    puts "\nYou see: #{items.map { |i| Registry.item(i).name }.join(', ')}" unless items.empty?
    puts "\nExits: #{area.exits.keys.join(', ')}"
    puts "Type 'help' for commands."
    puts "HP #{Health.bar(@player.hp, @player.max_hp, 10)}"
  end

  def handle(input)
    return if input.empty?

    input = input.sub(/\Ago /, "")
    return if area.run_action(self, input)

    if area.exits.key?(input)
      move_to(area.exits[input])
    elsif !Actions.dispatch(self, input)
      puts "You can't do that. (try 'help')"
      UI.pause
    end
  end

  def game_over
    @running = false
    puts "\nYou collapse... Game over."
    UI.pause
  end
end
