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
var phase = null
var stage = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	table = input_.table


func init_basic_setting() -> void:
	banner = Global.arr.side.front()
	phase = Global.arr.phase.front()
	stage = Global.dict.phase.stage[phase].front()
	
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
	
	#while table.loser == null:
	#	next_stage()
#endregion


func pass_banner() -> void:
	banner = Global.dict.chain.side[banner]
	var combo = get(banner)
	
	if !locks.has(combo.gambler):
		combo.risk_assessment()
		update_libra()
	else:
		pass_banner()
	
	if locks.size() == gamblers.keys().size() or loser != null:
		next_stage()


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
	
	#print([winner.health.index.get_number(), loser.health.index.get_number()])


func penalty_for_loser() -> void:
	if libra.subtype != "equilibrium":
		update_loser()
		var damage = 0
		
		for medal in Global.arr.medal:
			var gambler = get(medal)
			var side = gamblers[gambler]
			var combo = get(side)
			
			match medal:
				"winner":
					damage -= combo.amountValue.get_number()
				"loser":
					if combo.amountValue.get_number() <= combo.limitValue.get_number():
						damage += combo.amountValue.get_number()
		
		loser.health.change_integrity(damage)
		loser = null
		winner = null


func update_loser() -> void:
	if loser == null:
		for gambler in gamblers:
			if gamblers[gambler] != libra.subtype:
				set_loser(gambler)
				break


func follow_stage() -> void:
	print([phase, stage])
	call(stage)


func next_stage() -> void:
	var index = Global.dict.phase.stage[phase].find(stage) + 1
	
	if index == Global.dict.phase.stage[phase].size():
		next_phase()
	else:
		stage = Global.dict.phase.stage[phase][index]


func next_phase() -> void:
	phase = Global.dict.chain.phase[phase]
	stage = Global.dict.phase.stage[phase].front()


func preparing() -> void:
	update_libra()
	
	for gambler in table.gamblers:
			gambler.gameboard.hand.refill()
	
	next_stage()


func balancing() -> void:
	if locks.size() < gamblers.keys().size() and loser == null:
		pass_banner()
	else:
		next_stage()


func reckoning() -> void:
	penalty_for_loser()
	
	for gambler in table.gamblers:
		gambler.gameboard.hand.discard()
		
		var side = gamblers[gambler]
		var combo = get(side)
		combo.reset()
	
	next_stage()
