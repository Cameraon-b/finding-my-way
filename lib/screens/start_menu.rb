module StartMenu
  module_function

  # Returns :new_game or exits the program.
  def run(dev: false)
    loop do
      UI.clear
      UI.header(GAME_TITLE)
      puts "\n  1) New Game"
      puts "  2) How to Play"
      puts "  3) Quit"
      puts "  4) Dev Tools" if dev
      case UI.choose(dev ? %w[1 2 3 4] : %w[1 2 3])
      when "1" then return :new_game
      when "2" then HowToPlay.run
      when "3" then (puts "Goodbye!"; exit)
      when "4" then DevMenu.run(nil)
      end
    end
  end
end
