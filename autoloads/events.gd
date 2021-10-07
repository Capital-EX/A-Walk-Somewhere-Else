extends Node
signal curse(who)
signal bless(who)

enum { TYPE_ACCEPT, TYPE_REJECT, TYPE_FLEE, TYPE_FIGHT, TYPE_FREE_ALONE, TYPE_FREE_WITH_DOG, TYPE_FREE_WITH_CAT, TYPE_REST }
enum { ENEMY_WOLVES, ENEMY_BEAR, ENEMY_BUCK, ENEMY_BIRDS }
enum { CAUGHT_DOG, CAUGHT_CAT }

var events = [
	{
		description = """
			You encounter a sickly old %s in the middle of the path. %s says %s can heal one of your pets. However, %s requests that you forage food for %s.

			Do you accept, or do you reject.
		""",
		choices = [
			{
				name = "ACCEPT",
				type = TYPE_ACCEPT
			},
			{
				name = "REJECT",
				type = TYPE_REJECT
			}
		],
		flavors = [
			['man', 'He', 'he', 'he', 'him'], 
			['woman', 'She', 'she', 'she', 'her'], 
			['person', 'They', 'they', 'they', 'them']
		],
	},

	{
		description = """
			You encounter a group of fungis infested wolves. %s
			
			Do you fight, or do you flee?
		""",
		choices = [
			{
				name = "FLEE",
				type = TYPE_FLEE,
				enemy = ENEMY_WOLVES
			},
			{
				name = "FIGHT",
				type = TYPE_FIGHT,
				enemy = ENEMY_WOLVES
			}
		],
		flavors = [
			["The animals are sickly with mushroom caps poking out of their fur."],
			["Their heads convulse and shake. The mushroom in their eyes seem to pulse with each twitch."],
			["Their breathing is labored from the mushrooms growing out of their rib cages."],
			["Despite being blinded, the wolves shamble around you with perfect synchronization."]
		]
	},

	{
		description = """
			You encounter an insectoid infested bear. %s
			
			Do you fight, or do you flee?
		""",
		choices = [
			{
				name = "FLEE",
				type = TYPE_FLEE,
				enemy = ENEMY_BEAR
			},
			{
				name = "FIGHT",
				type = TYPE_FIGHT,
				enemy = ENEMY_BEAR
			}
		],
		flavors = [
			["Chitinous legs poke through its skin. They twitch and move sporadically."],
			["Its fur falls off in clumps revealing a dark iradesant exoskeloton."],
			["The eyes of the bear have been mutated into the compound eyes of an insect."],
			["The bear's mouth has morphed into the mandibles of an insect. They chitter violently."]
		],
	},

	{
		description = """
			You encounter a tree infested buck. %s

			Do you fight, or do you flee?
		""",
		choices = [
			{
				name = "FLEE",
				type = TYPE_FLEE,
				enemy = ENEMY_BUCK
			},
			{
				name = "FIGHT",
				type = TYPE_FIGHT,
				enemy = ENEMY_BUCK
			}
		],
		flavors = [
			["Twisted and gnarled branches brust from its flesh. You can hear them creak with its every move."],
			["The eyes of the buck have been completely consumed by the plants growing out of it."],
			["Its gate is stiff and uneven from the branches growing in its legs."],
			["Despite its eyes having been eaten by woody branches, you can't help but feel it's staring directly at you."]
		]
	},

	{
		description = """
			The trees thrash to life, they wrap themselves around your beloved DOG.

			Free them BY YOURSELF, or free them WITH YOUR CAT'S help.
		""",
		choices = [
			{
				name = "FREE ALONE",
				type = TYPE_FREE_ALONE,
				caught = CAUGHT_DOG
			},
			{
				name = "FREE WITH HELP",
				type = TYPE_FREE_WITH_CAT,
				caught = CAUGHT_DOG
			}
		]
	},

	{
		description = """
			The trees thrash to life, they wrap themselves around your beloved cat.

			Free them BY YOURSELF, or free them WITH YOUR DOG'S help.
		""",
		choices = [
			{
				name = "FREE ALONE",
				type = TYPE_FREE_ALONE,
				caught = CAUGHT_CAT,
			},
			{
				name = "FREE WITH HELP",
				type = TYPE_FREE_WITH_DOG,
				caught = CAUGHT_CAT,
			}
		]
	},

	{
		description = """
			The trees above you break out into a cacaphony as countless fungal infested birds swarm you. %s
		""",
		choices = [
			{
				name = "FLEE",
				type = TYPE_FLEE,
				enemy = ENEMY_BIRDS
			},
			{
				name = "FIGHT",
				type = TYPE_FIGHT,
				enemy = ENEMY_BIRDS
			}
		],
		flavors = [
			["Their heads have all been replaced with a flesh mushroom mass."],
			["Their calls are broken and rashpy from the mushrooms growing out their necks."],
			["Their flying is unstable do to mushroom growing out of their shoulders."],
			["The birds sitting on the branches twitch and shake from the mushrooms growing out of their head."]
		]
	},
	
	{
		description = """
			You encounter a group of %s. They offer you food and a safe place to rest.
		""",
		choices = [
			{
				name = "REST",
				type = TYPE_REST,
			}
		],
		flavors = [
			["travelers"], ["merchants"], ["nomads"], ["explorers"], ["knights"], ["refugees"]
		]
	}
]

var reject_string = 0
var last_healed = -1
func apply_effect(choice: Dictionary) -> String:
	match choice.type:
		TYPE_ACCEPT:
			var healed = -1
			if State.get_state('cat').curses.size() == State.get_state('dog').curses.size():
				healed = (last_healed + 1) % 2

			elif State.get_state('cat').curses.size() > State.get_state('dog').curses.size():
				healed = 0

			else:
				healed = 1
			
			last_healed = healed
			match healed:
				0:
					emit_signal('bless', 'cat')
					return "You search the area for food. Once you bring it back the old and sickly person BLESSES your CAT."

				1:
					emit_signal('bless', 'dog')
					return "You search the area for food. Once you bring it back the old and sickly person BLESSES your DOG."
				
				3:
					return "They thank you for so kindly helping them, despite needing nothing in return."
				
				_:
					return "[THIS IS AN ERROR TYPE_ACCEPT]"
		
		TYPE_REJECT:
			if reject_string > 0 and randf() * 0.5 * reject_string > 0.8:
				if randf() > 0.5:
					emit_signal('curse', 'dog')
					return "Irate with being ignored, the sickly person places a CURSE on your DOG"
				else:
					emit_signal('curse', 'cat')
					return "Irate with being ignored, the sickly person places a CURSE on your CAT"
				
			else:
				reject_string += 1
				return "You pass by the sickly person. They stare at you with pleading eyes as you leave them alone in the forest."
			
		TYPE_FIGHT:
			var enemy: String
			var you = State.get_state('you')
			you.health = max(you.health - 10, 0)
			
			State.update('you', you)

			match choice.enemy:
				ENEMY_WOLVES:
					enemy = "wolves"
				
				ENEMY_BEAR:
					enemy = "bear"
				
				ENEMY_BIRDS:
					enemy = "bird"
				
				ENEMY_BUCK:
					enemy = "buck"
			
			return "You are attacked by the %s. However, you managed to fend them off and protect your beloved pets." % enemy
			
		TYPE_FLEE:
			var enemy: String

			var cat = State.get_state('cat')
			var dog = State.get_state('dog')
			var you = State.get_state('you')
			
			var cat_damage = max(cat.hunger + 20 - 100, 0)
			var dog_damage = max(dog.hunger + 20 - 100, 0)
			var you_damage = max(you.hunger + 20 - 100, 0)

			cat.hunger = min(cat.hunger + 20, 100)
			dog.hunger = min(dog.hunger + 20, 100)
			you.hunger = min(you.hunger + 20, 100)
			
			cat.health = max(cat.health - cat_damage, 0)
			dog.health = max(cat.health - cat_damage, 0)
			you.health = max(cat.health - cat_damage, 0)
			

			State.update('cat', cat)
			State.update('dog', dog)
			State.update('you', you)

			match choice.enemy:
				ENEMY_WOLVES:
					enemy = "wolves"
				
				ENEMY_BEAR:
					enemy = "bear"
				
				ENEMY_BIRDS:
					enemy = "bird"
				
				ENEMY_BUCK:
					enemy = "buck"
				
			return "You flee from the %s. As you run, you can hear the %s fade into the distance. It leaves all of you exhausted." % [enemy, enemy]
			
		TYPE_FREE_ALONE:
			var you = State.get_state('you')
			you.health = max(you.health - 15, 0)

			match choice.caught:
				CAUGHT_DOG:
					return "Not wanting to put your cat in danger, you free your dog alone. The wooden vines leave you battered and brused."
				CAUGHT_CAT:
					return "Not wanting to put your dog in danger, you free your cat alone. The wooden vines leave you battered and brused."
				
				_:
					return "[THIS IS AN ERROR TYPE_FREE_ALONE]"
		
		TYPE_FREE_WITH_CAT:
			var cat = State.get_state('cat')
			var you = State.get_state('you')

			cat.health = max(cat.health - 5, 0)
			you.health = max(you.health - 5, 0)

			State.update('dog', cat)
			State.update('you', you)


			return "You free your dog with your cat's help. It goes faster, but leaves you both stung from the vines."
		
		TYPE_FREE_WITH_DOG:
			var dog = State.get_state('dog')
			var you = State.get_state('you')

			dog.health = max(dog.health - 5, 0)
			you.health = max(you.health - 5, 0)

			State.update('dog', dog)
			State.update('you', you)

			return "You free your cat with your dog's help. It goes faster, but leaves you both stung from the vines."
		
		TYPE_REST:
			var cat = State.get_state('cat')
			var dog = State.get_state('dog')
			var you = State.get_state('you')

			cat.health = min(cat.health + 25, 100)
			cat.hunger = max(cat.hunger - 50, 0)

			dog.health = min(dog.health + 25, 100)
			dog.hunger = max(dog.hunger - 50, 0)

			you.health = min(you.health + 25, 100)
			you.hunger = max(you.hunger - 50, 0)

			State.update('cat', cat)
			State.update('dog', dog)
			State.update('you', you)

			return "You enjoy the brieve repreive from your travels."
		
		_:
			return "[THIS IS AN ERROR UNKNOW TYPE]"


func get_random_event() -> Dictionary:
	return events[0]
	return events[randi() % len(events)]

func get_description(event: Dictionary) -> String:
	if event.has('flavors'):
		return event.description.strip_edges().dedent() % event.flavors[randi() % len(event.flavors)]
	else:
		return event.description.strip_edges().dedent()

func get_choices(id: int) -> Array:
	return events[id].get('choices', [])

func get_choice_info(choice: Dictionary) -> String:
	match choice.type:
		TYPE_ACCEPT:
			return """
				[PET RESTORED]
				[YOUR HUNGER +25]
			""".strip_edges().dedent()
		
		TYPE_REJECT:
			return """
				[CONTINUE WALKING]
			""".strip_edges().dedent()
			
		TYPE_FIGHT:
			return """
				[YOUR HEALTH -10]
			""".strip_edges().dedent()
			
		TYPE_FLEE:
			return """
				[ALL HUNGER +20]
			""".strip_edges().dedent()
			
		TYPE_FREE_ALONE:
			return """
				[YOUR HEALTH -15]
			""".strip_edges().dedent()
		
		TYPE_FREE_WITH_CAT:
			return """
				[YOUR HEALTH -5]
				[CAT'S HEALTH -5]
			""".strip_edges().dedent()
		
		TYPE_FREE_WITH_DOG:
			return """
				[YOUR HEALTH -5]
				[DOG'S HEALTH -5]
			""".strip_edges().dedent()
		
		TYPE_REST:
			return """
				[ALL HEALTH +25]
				[ALL HUNGER -50]
			""".strip_edges().dedent()
		
		_:
			return ""

