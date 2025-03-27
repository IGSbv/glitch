extends Node
class_name DecisionManager

signal decision_made(player_id, decision, outcome)

var decision_history = {}

@onready var game_manager = get_node("/root/GameManager")  # Ensure GameManager is correctly referenced

func _ready():
	print("[Decision] Decision Manager Initialized")

func make_financial_decision(player_id, decision_type, amount):
	if !game_manager.players_data.has(player_id):
		return
	
	var outcome = {}
	var player_data = game_manager.players_data[player_id]
	
	match decision_type:
		"investment":
			outcome = handle_investment(player_id, amount)
		"loan":
			outcome = handle_loan(player_id, amount)
		"asset_purchase":
			outcome = handle_asset_purchase(player_id, amount)
		"spending":
			outcome = handle_spending(player_id, amount)
		_:
			outcome = {"status": "error", "message": "Invalid decision"}
	
	decision_history[player_id] = outcome
	send_decision_update(player_id, decision_type, outcome)

func handle_investment(player_id, amount):
	var risk_factor = randf_range(0.5, 2.0)
	var profit_or_loss = amount * (risk_factor - 1)
	
	game_manager.update_player_finances(player_id, profit_or_loss, 0)
	
	return {
		"status": "success",
		"change": profit_or_loss,
		"message": "Investment resulted in " + str(profit_or_loss) + " coins"
	}

func handle_loan(player_id, amount):
	var interest_rate = game_manager.interest_rate / 100
	var total_repayment = amount + (amount * interest_rate)
	
	game_manager.update_player_finances(player_id, amount, 0)
	
	return {
		"status": "success",
		"debt": total_repayment,
		"message": "Loan approved. Repay " + str(total_repayment) + " coins"
	}

func handle_asset_purchase(player_id, amount):
	if game_manager.players_data[player_id]["coins"] < amount:
		return {"status": "failed", "message": "Insufficient funds"}
	
	game_manager.players_data[player_id]["coins"] -= amount
	game_manager.players_data[player_id]["assets"].append(amount)
	
	return {
		"status": "success",
		"message": "Asset purchased for " + str(amount) + " coins"
	}

func handle_spending(player_id, amount):
	if game_manager.players_data[player_id]["coins"] < amount:
		return {"status": "failed", "message": "Not enough money!"}
	
	game_manager.players_data[player_id]["coins"] -= amount
	return {"status": "success", "message": "Spent " + str(amount) + " coins"}

func send_decision_update(player_id, decision_type, outcome):
	rpc("receive_decision_update", player_id, decision_type, outcome)

@rpc("authority", "reliable")
func receive_decision_update(player_id, decision_type, outcome):
	decision_history[player_id] = outcome
	decision_made.emit(player_id, decision_type, outcome)
	print("[Decision] Player", player_id, "made a", decision_type, "decision:", outcome)
