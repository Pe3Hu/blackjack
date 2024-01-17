extends MarginContainer


#region vars
@onready var gamblers = $Gamblers

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_gamblers()


func init_gamblers() -> void:
	for _i in 2:
		var input = {}
		input.cradle = self
	
		var gambler = Global.scene.gambler.instantiate()
		gamblers.add_child(gambler)
		gambler.set_attributes(input)
#endregion
