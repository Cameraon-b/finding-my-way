module HowToPlay
  module_function

  def run
    UI.clear
    puts "HOW TO PLAY\n\n"
    puts "Type commands and press Enter. Move by typing an exit name (e.g. 'north')."
    puts "Try: look, take <item>, use <item>, inventory, stats, help, quit."
    UI.pause
  end
end
