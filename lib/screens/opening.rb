module Opening
  module_function

  # Plays the intro and returns a new Player.
  def run
    UI.clear
    UI.slow_print("You wake to the sound of rain on leaves...")
    UI.slow_print("Your head aches. You don't remember how you got here.")
    UI.slow_print("Around you, tall trees crowd out the sky.")
    UI.pause
    name = UI.ask("\nWhat is your name? ")
    name = "Traveler" if name.empty?
    UI.slow_print("\n#{name}... yes, that sounds right.")
    UI.pause
    Player.new(name)
  end
end
