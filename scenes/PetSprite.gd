extends Node2D
var target: String

func apply_curse(curse: int) -> Node2D:
	var curse_count = len(State.get_state(target).curses)
	var active
	if curse_count == 6:
		emit_signal('died')
		return null
		
	match curse:
		Foods.CURSE_BUG:
			active = $BugMutation.get_child(curse_count)
		
		Foods.CURSE_MUSHROOM:
			active = $MushroomMutations.get_child(curse_count)
		
		Foods.CURSE_TREE:
			active = $TreeMutations.get_child(curse_count)
	
	active.appear()
	return active

func frown() -> void:
	$Base.hide()
	$Sad.show()

func normal() -> void:
	$Sad.hide()
	$Base.show()
