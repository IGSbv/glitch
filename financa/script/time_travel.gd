extends Node
class_name TimeTravelManager

@onready var game_manager = get_node("/root/GameManager")  

var decision_history = {}  # Stores past states per player

func _ready():
	print("[Time Travel] Initialized.")

func save_decision_state(player_id, coins, gems, assets):
	if player_id not in decision_history:
		decision_history[player_id] = []

	# Store the player's last decision
	decision_history[player_id].append({
		"coins": coins,
		"gems": gems,
		"assets": assets.duplicate(true)  # Deep copy assets to avoid reference issues
	})

	print("[Time Travel] Saved state for player", player_id)

func rewind_time(player_id):
	if player_id in game_manager.players_data and player_id in decision_history:
		if game_manager.players_data[player_id]["gems"] < 1:
			print("[Time Travel] Not enough gems to rewind!")
			return false

		if decision_history[player_id].size() > 0:
			var last_state = decision_history[player_id].pop_back()  # Get the last saved state

			game_manager.players_data[player_id]["coins"] = last_state["coins"]
			game_manager.players_data[player_id]["gems"] -= 1  # Deduct gems
			game_manager.players_data[player_id]["assets"] = last_state["assets"]

			print("[Time Travel] Reverted to previous state for player", player_id)
			print("[Time Travel] Coins:", last_state["coins"], "Gems:", game_manager.players_data[player_id]["gems"])
			
			return true
		else:
			print("[Time Travel] No previous state to revert to!")
			return false
	else:
		print("[Time Travel] Player not found or missing data!")
		return false

func ai_advisory_rewind(player_id):
	if player_id in game_manager.players_data:
		var current_coins = game_manager.players_data[player_id]["coins"]
		var risky_assets = game_manager.players_data[player_id]["assets"].filter(func(asset): return asset["value"] < 0)

		if current_coins < 0 or risky_assets.size() > 2:
			print("[AI Advisory] Rewinding recommended for player", player_id)
			return true
		else:
			print("[AI Advisory] No need to rewind. Financial status is stable.")
			return false
