extends MarginContainer


#region vars
@onready var amount = $VBox/Amount
@onready var limit = $VBox/Limit
@onready var chance = $VBox/Chance

var croupier = null
var gamblers = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	croupier = input_.croupier
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_icons()


func init_icons() -> void:
	var keys = ["amount", "limit", "chance"]
	var input = {}
	input.type = "number"
	input.subtype = 0
	
	for key in keys:
		var icon = get(key)
		icon.set_attributes(input)
	
	limit.set_number(Global.num.apotheosis.amount)
#endregion


func update_amount(card_: MarginContainer) -> void:
	var rank = card_.rank.get_number()
	amount.change_number(rank)
	
	if fiasco_check():
		print("fiasco")


func fiasco_check() -> bool:
	return amount.get_number() > limit.get_number()


func calculate_chance_of_fiasco() -> void:
	var outcomes = {}
