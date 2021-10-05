extends PanelContainer

var item

func _ready() -> void:
	randomize()
	var curse
	if randf() > 0.9:
		curse = 'restore'
	else:
		curse = Foods.items.keys()[randi() % 4 + 1]
	var item_count = len(Foods.items[curse])
	item = Foods.items[curse][randi() % item_count]
	$TextureRect.texture = item.texture

func get_drag_data(position):
	var copy = $TextureRect.duplicate()
	copy.margin_left = -50
	copy.margin_top = -50
	copy.margin_right = 50
	copy.margin_bottom = 50
	var control = Control.new()
	control.add_child(copy)
	set_drag_preview(control)
	return {food = item, source = self}
