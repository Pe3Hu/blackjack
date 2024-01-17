extends MarginContainer


#region vars
@onready var vbox = $VBox
@onready var croupier = $VBox/Croupier

var casino = null
var gamblers = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	casino = input_.casino
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.table = self
	croupier.set_attributes(input)


func add_gambler(gambler_: MarginContainer) -> void:
	casino.sketch.cradle.gamblers.remove_child(gambler_)
	vbox.add_child(gambler_)
	
	if gamblers.is_empty():
		vbox.move_child(gambler_, 0)
	
	gamblers.append(gambler_)
	gambler_.table = self
#endregion
