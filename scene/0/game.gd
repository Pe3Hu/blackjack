extends Node


@onready var sketch = $Sketch


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					sketch.casino.tables.get_child(0).croupier.follow_stage()
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					sketch.casino.tables.get_child(0).gamblers.front().health.change_integrity(-10)
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					sketch.casino.tables.get_child(0).gamblers.front().health.change_integrity(10)

