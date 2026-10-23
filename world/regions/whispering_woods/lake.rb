Area.define :woods_lake do
  in_region :whispering_woods
  title "Moonlit Lake"
  describe "A still lake reflects the moonlight. The clearing is to the west."
  exit_to "west", :woods_clearing
  has_item :rusty_key
  encounter :wolf
end
