extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.rank = [1, 2, 3, 4, 5]#, 6]
	arr.suit = ["aqua", "wind", "fire", "earth"]
	arr.side = ["left", "right"]


func init_num() -> void:
	num.index = {}
	num.index.card = 0
	num.index.gambler = 0
	
	num.apotheosis = {}
	num.apotheosis.amount = 24


func init_dict() -> void:
	init_neighbor()
	init_card()
	
	dict.chain = {}
	dict.chain.area = {}
	dict.chain.area[null] = "discharged"
	dict.chain.area["discharged"] = "available"
	dict.chain.area["available"] = "hand"
	dict.chain.area["hand"] = "discharged"
	dict.chain.area["broken"] = "discharged"
	
	dict.chain.side = {}
	dict.chain.side["right"] = "left"
	dict.chain.side["left"] = "right"
	
	dict.donor = {}
	dict.donor.area = {}
	dict.donor.area["available"] = "discharged"
	dict.donor.area["hand"] = "available"


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_card_old() -> void:
	dict.card = {}
	dict.card.count = {}
	
	for rank in arr.rank:
		dict.card.count[rank] = arr.rank.front() + arr.rank.back() - rank


func init_card() -> void:
	arr.rank = [3, 4, 6, 8, 12]
	dict.card = {}
	dict.card.count = {}
	arr.suit = ["spades"]#["clubs", "diamonds", "hearts", "spades"]
	
	for rank in arr.rank:
		dict.card.count[rank] = num.apotheosis.amount / rank


func init_emptyjson() -> void:
	dict.emptyjson = {}
	dict.emptyjson.title = {}
	
	var path = "res://asset/json/.json"
	var array = load_data(path)
	
	for emptyjson in array:
		var data = {}
		
		for key in emptyjson:
			if key != "title":
				data[key] = emptyjson[key]
		
		dict.emptyjson.title[emptyjson.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.gambler = load("res://scene/1/gambler.tscn")
	
	scene.table = load("res://scene/2/table.tscn")
	
	scene.card = load("res://scene/3/card.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.suit = Vector2(32, 32)
	
	vec.size.rank = Vector2(vec.size.sixteen)
	vec.size.combo = Vector2(vec.size.sixteen) * 2
	vec.size.gambler = Vector2(vec.size.sixteen) * 3
	vec.size.libra = Vector2(vec.size.sixteen) * 4
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.card = {}
	color.card.selected = Color.from_hsv(160 / h, 0.6, 0.7)
	color.card.unselected = Color.from_hsv(0 / h, 0.4, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
