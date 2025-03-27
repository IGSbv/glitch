extends Node
class_name GameManager

# Player financial data
var players_data = {}

# Economy variables
var inflation_rate = 2.5
var interest_rate = 5.0
var tax_rate = 15.0

# Multiplayer signals
signal financial_update(player_id, data)
signal economic_event(event_data)

func _ready():
	print("[Game] Game Manager Initialized")

# Register player in the economy
func register_player(player_id):
	players_data[player_id] = {
		"coins": 1000,
		"gems": 50,
		"financial_health": 75.0,
		"credit_score": 650,
		"assets": []
	}
	print("[Game] Player Registered: ", player_id)
	send_financial_update(player_id)

# Modify player's financial state
func update_player_finances(player_id, coins_change, gems_change):
	if players_data.has(player_id):
		players_data[player_id]["coins"] += coins_change
		players_data[player_id]["gems"] += gems_change
		send_financial_update(player_id)

# Send financial data update to all clients
func send_financial_update(player_id):
	rpc("receive_financial_update", player_id, players_data[player_id])

@rpc("authority", "reliable")
func receive_financial_update(player_id, data):
	players_data[player_id] = data
	print("[Game] Financial Update Received: ", data)
	financial_update.emit(player_id, data)

# Simulate economy changes (inflation, interest rates, tax updates)
func update_economy():
	inflation_rate += randf_range(-0.3, 0.5)  # Small fluctuation
	interest_rate += randf_range(-0.5, 0.5)
	tax_rate += randf_range(-1, 1)
	
	var event_data = {
		"inflation_rate": inflation_rate,
		"interest_rate": interest_rate,
		"tax_rate": tax_rate
	}
	
	rpc("receive_economic_event", event_data)

@rpc("authority", "reliable")
func receive_economic_event(event_data):
	print("[Game] Economic Event: ", event_data)
	economic_event.emit(event_data)

# Handle AI-generated financial events
func trigger_ai_financial_event():
	var event = {
		"type": "market_crash",
		"impact": -20,
		"message": "AI Predicts a Stock Market Crash! Prepare for losses!"
	}
	rpc("receive_financial_event", event)

@rpc("authority", "reliable")
func receive_financial_event(event):
	print("[Game] AI Financial Event: ", event)
	economic_event.emit(event)
