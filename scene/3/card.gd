extends MarginContainer


#region vars
@onready var bg = $BG
@onready var suit = $Suit
@onready var rank = $Rank

var area = null
var gameboard = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.type = "suit"
	input.subtype = input_.suit
	suit.set_attributes(input)
	custom_minimum_size = Global.vec.size.suit
	
	input.type = "number"
	input.subtype = input_.rank
	rank.set_attributes(input)
	rank.custom_minimum_size = Global.vec.size.rank
	
	#suit.set("theme_override_constants/margin_left", 4)
	#suit.set("theme_override_constants/margin_top", 4)
	custom_minimum_size = suit.custom_minimum_size + rank.custom_minimum_size * 0.6

	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	set_selected(false)
#endregion


func set_selected(selected_: bool) -> void:
	var style = bg.get("theme_override_styles/panel")
	
	match selected_:
		true:
			style.bg_color = Global.color.card.selected
			pass
		false:
			style.bg_color = Global.color.card.unselected


func advance_area() -> void:
	var cardstack = null
	
	if area == null:
		area = Global.dict.chain.area[area]
		advance_area()
	else:
		cardstack = gameboard.get(area)
		cardstack.cards.remove_child(self)
	
		area = Global.dict.chain.area[area]
		cardstack = gameboard.get(area)
		cardstack.cards.add_child(self)
	
	if area == "hand":
		gameboard.gambler.combo.update_amount(self)
