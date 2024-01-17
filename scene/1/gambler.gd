extends MarginContainer


#region vars
@onready var gameboard = $VBox/Gameboard
@onready var index = $VBox/Index

var cradle = null
var table = null
var combo = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.gambler = self
	gameboard.set_attributes(input)
	init_index()


func init_index() -> void:
	var input = {}
	input.type = "gambler"
	input.subtype = Global.num.index.gambler
	index.set_attributes(input)
	Global.num.index.gambler += 1
#endregion
