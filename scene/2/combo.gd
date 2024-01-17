extends MarginContainer


#region vars
@onready var chanceIcon = $VBox/Chance/Icon
@onready var amountIcon = $VBox/Amount/Icon
@onready var limitIcon = $VBox/Limit/Icon
@onready var chanceValue = $VBox/Chance/Value
@onready var amountValue = $VBox/Amount/Value
@onready var limitValue = $VBox/Limit/Value

var croupier = null
var gambler = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	croupier = input_.croupier
	gambler = input_.gambler
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_icons()


func init_icons() -> void:
	var keys = ["amount", "limit", "chance"]
	var groups = ["Icon", "Value"]
	var types = {}
	types["Icon"] = "combo"
	types["Value"] = "number"
	
	for group in groups:
		var input = {}
		input.type = types[group]
		input.subtype = 0
		
		for key in keys:
			if group == "Icon":
				input.subtype = key
			
			var icon = get(key + group)
			icon.set_attributes(input)
	
	limitValue.set_number(Global.num.apotheosis.amount)
#endregion


func update_amount(card_: MarginContainer) -> void:
	var rank = card_.rank.get_number()
	amountValue.change_number(rank)
	
	if fiasco_check():
		print(["fiasco", gambler.index.subtype])
		croupier.set_loser(gambler)
		chanceValue.set_number(100)
	else:
		calculate_chance_of_fiasco()


func fiasco_check() -> bool:
	return amountValue.get_number() > limitValue.get_number()


func calculate_chance_of_fiasco() -> void:
	var overabundance = limitValue.get_number() - amountValue.get_number() + 1
	var outcomes = {}
	outcomes.total = gambler.gameboard.available.cards.get_child_count()
	outcomes.success = 0
	outcomes.failure = 0
	
	for card in gambler.gameboard.available.cards.get_children():
		if card.rank.get_number() < overabundance:
			outcomes.success += 100.0 / outcomes.total
	
	outcomes.failure = 100.0 - outcomes.success
	print([amountValue.get_number(), outcomes])
	chanceValue.set_number(int(outcomes.failure))


func risk_assessment() -> void:
	if chanceValue.get_number() < 50:
		gambler.gameboard.available.advance_random_card()
	else:
		lock_in()


func lock_in() -> void:
	croupier.locks.append(gambler)
