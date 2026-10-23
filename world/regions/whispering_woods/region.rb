Region.define :whispering_woods, name: "The Whispering Woods", start: :woods_clearing

Item.define :rusty_key, name: "Rusty Key", description: "Old and flaking. It must open something."
Item.define :old_knife, name: "Old Knife", description: "Dull, but better than bare hands.", attack_bonus: 2
Item.define :healing_herb, name: "Healing Herb", description: "Restores 8 HP.",
            on_use: lambda { |game|
              healed = Health.heal(game.player, 8)
              puts "You chew the herb and recover #{healed} HP."
            }

Enemy.define :wolf, name: "Grey Wolf", hp: 8, damage: 1..3,
             intro: "A grey wolf slinks out of the reeds, teeth bared!", loot: [:healing_herb]
