extends Node

class Food:
	extends Reference
	
	var name: String
	var curse: int
	var texture: Texture
	
	func _init(name: String, curse: int, texture: Texture) -> void:
		self.name = name
		self.curse = curse
		self.texture = texture

enum { CURSE_NONE, CURSE_RESTORE, CURSE_MUSHROOM, CURSE_BUG, CURSE_TREE }

var items =  {
	restore = [ 
		Food.new('Golden Fruit', CURSE_RESTORE, preload("res://imgs/foods/food-01.png")) 
	],
	none = [
		Food.new('Blue Berries', CURSE_NONE, preload("res://imgs/foods/food-02.png")),
		Food.new('Strawberry', CURSE_NONE, preload("res://imgs/foods/food-03.png"))
	],
	
	mushroom = [
		Food.new('Toadstools', CURSE_MUSHROOM, preload("res://imgs/foods/food-04.png")),
		Food.new('Molded Fruit', CURSE_MUSHROOM, preload("res://imgs/foods/food-05.png")),
		Food.new('Barkwood Shrooms', CURSE_MUSHROOM, preload("res://imgs/foods/food-06.png")),
	],
	
	tree = [
		Food.new('Sweet Flower', CURSE_TREE, preload("res://imgs/foods/food-07.png")),
		Food.new('Pinkerdale', CURSE_TREE, preload("res://imgs/foods/food-08.png")),
		Food.new('Starpetal', CURSE_TREE, preload("res://imgs/foods/food-09.png")),
	],
	
	bug = [
		Food.new('Cricket', CURSE_BUG, preload("res://imgs/foods/food-10.png")),
		Food.new('Infested Berries', CURSE_BUG, preload("res://imgs/foods/food-11.png")),
		Food.new('Acrused Grub', CURSE_BUG, preload("res://imgs/foods/food-12.png")),
	]

}

func _ready() -> void:
	pass

