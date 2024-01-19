extends MarginContainer


#region vars
@onready var gameboard = $VBox/Gameboard
@onready var health = $VBox/Health

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
	
	input.limits = {}
	input.limits.vigor = 0.25
	input.limits.standard = 0.5
	input.limits.fatigue = 0.25
	input.total = 100
	health.set_attributes(input)
#endregion
