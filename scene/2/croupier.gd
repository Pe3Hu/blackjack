extends MarginContainer


#region vars
@onready var left = $HBox/Left
@onready var appraisal = $HBox/Appraisal
@onready var right = $HBox/Right

var table = null
var gamblers = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	table = input_.table


func init_basic_setting() -> void:
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var gambler = table.gamblers[_i]
		gamblers[gambler] = side
		var combo = get(side)
		gambler.combo = combo
		
		var input = {}
		input.croupier = self
		combo.set_attributes(input)


func commence() -> void:
	init_basic_setting()
	next_turn()
#endregion


func next_turn() -> void:
	for gambler in table.gamblers:
		gambler.gameboard.hand.refill()
