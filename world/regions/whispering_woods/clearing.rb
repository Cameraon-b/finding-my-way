Area.define :woods_clearing do
  in_region :whispering_woods
  title "Forest Clearing"
  describe "You stand in a damp forest clearing. A path leads north; " \
           "a faint light glows to the east."
  exit_to "north", :woods_cabin
  exit_to "east", :woods_lake
end
