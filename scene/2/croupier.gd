extends MarginContainer


#region vars
@onready var left = $HBox/Left
@onready var libra = $HBox/Libra
@onready var right = $HBox/Right

var table = null
var gamblers = {}
var banner = null
var locks = []
var loser = null
var winner = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	table = input_.table


func init_basic_setting() -> void:
	banner = Global.arr.side.front()
	
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var gambler = table.gamblers[_i]
		gamblers[gambler] = side
		var combo = get(side)
		gambler.combo = combo
		
		var input = {}
		input.croupier = self
		input.gambler = gambler
		combo.set_attributes(input)


func commence() -> void:
	init_basic_setting()
	next_turn()
#endregion


func next_turn() -> void:
	for gambler in table.gamblers:
		gambler.gameboard.hand.refill()
	
	while locks.size() < gamblers.keys().size() and loser == null:
		pass_banner()


func pass_banner() -> void:
	banner = Global.dict.chain.side[banner]
	var combo = get(banner)
	
	if !locks.has(combo.gambler):
		combo.risk_assessment()
		update_libra()
	else:
		pass_banner()


func update_libra() -> void:
	var input = {}
	input.type = "libra"
	
	if loser == null:
		var difference = left.amountValue.get_number() - right.amountValue.get_number()
		input.subtype = "equilibrium"
		
		if difference != 0:
			match sign(difference):
				1:
					input.subtype = "left"
				-1:
					input.subtype = "right"
	else:
		input.subtype = gamblers[winner] 
	
	libra.set_attributes(input)


func set_loser(loser_: MarginContainer) -> void:
	loser = loser_
	
	for gambler in gamblers:
		if gambler != loser:
			winner = gambler
			break
