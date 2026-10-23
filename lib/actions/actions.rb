# Command registry. Every typed command (look, take, inventory...) is an Action.
# To add one, drop a file in lib/actions/ and call Actions.register:
#
#   Actions.register("shout", aliases: %w[yell], help: "Shout loudly") do |game, args|
#     puts "You shout #{args}!"
#   end
module Actions
  Command = Struct.new(:name, :aliases, :help, :dev_only, :block)

  @commands = {}

  class << self
    attr_reader :commands

    def register(name, aliases: [], help: "", dev_only: false, &block)
      cmd = Command.new(name, aliases, help, dev_only, block)
      @commands[name] = cmd
    end

    def find(word)
      @commands.values.find { |c| c.name == word || c.aliases.include?(word) }
    end

    # Returns true if the input matched a command.
    def dispatch(game, input)
      word, args = input.split(" ", 2)
      cmd = find(word)
      return false if cmd.nil? || (cmd.dev_only && !game.dev)

      cmd.block.call(game, args.to_s)
      true
    end

    # Shared by the `use` command and combat.
    def use_item(game, item_id)
      item = Registry.item(item_id)
      unless item.usable?
        puts "You can't use the #{item.name} right now."
        return
      end
      consumed = item.on_use.call(game)
      Inventory.remove(game.player, item_id) unless consumed == false
    end
  end
end
