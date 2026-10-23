Area.define :woods_cabin do
  in_region :whispering_woods
  title "Abandoned Cabin"
  describe do |game|
    text = "An abandoned cabin sits here, door ajar. The path back is south."
    text += "\nA loose floorboard has been pried up." if game.player.flags[:searched_cabin]
    text
  end
  exit_to "south", :woods_clearing

  # Area-specific command, only available here.
  action "search" do |game, _|
    if game.player.flags[:searched_cabin]
      puts "You've already searched here."
    else
      game.player.flags[:searched_cabin] = true
      game.items_here << :old_knife
      puts "Under a floorboard you find an old knife."
    end
    UI.pause
    game.describe_area = true
  end
end
