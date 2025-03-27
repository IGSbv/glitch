extends Node
class_name BusinessSimulator

@onready var economy_manager = get_node("/root/EconomyManager")

var businesses = {}  # Dictionary storing player-owned businesses
var business_types = ["Tech Startup", "Retail Store", "Real Estate", "Manufacturing", "Finance Firm"]

func _ready():
	print("[Business] Simulator Initialized")

# 📌 Create a new business
func start_business(player_id, business_name, business_type):
	if business_type not in business_types:
		print("[Business] Invalid business type!")
		return false

	var initial_value = randi_range(50_000, 200_000)  # Initial business worth
	businesses[player_id] = {
		"name": business_name,
		"type": business_type,
		"value": initial_value,
		"monthly_profit": initial_value * 0.05,
		"employees": randi_range(5, 50),
		"growth_rate": randf_range(1.01, 1.05),
		"status": "Active",
		"loan": 0
	}
	print("[Business] " + business_name + " started by Player " + str(player_id))
	return true

# 📌 Calculate monthly business performance
func update_businesses():
	for player_id in businesses.keys():
		var biz = businesses[player_id]
		if biz["status"] == "Active":
			var economy_factor = economy_manager.gdp_growth / 100
			biz["value"] *= biz["growth_rate"] + economy_factor
			biz["monthly_profit"] *= (1.0 + economy_factor)
			print("[Business] " + biz["name"] + " updated! New Value: $" + str(biz["value"]))

# 📌 Take a business loan
func take_loan(player_id, amount):
	if player_id in businesses:
		businesses[player_id]["loan"] += amount
		businesses[player_id]["value"] += amount
		print("[Business] Player " + str(player_id) + " took a loan of $" + str(amount))

# 📌 Sell the business
func sell_business(player_id):
	if player_id in businesses:
		var payout = businesses[player_id]["value"]
		print("[Business] " + businesses[player_id]["name"] + " sold for $" + str(payout))
		businesses.erase(player_id)
		return payout
	return 0

# 📌 Fetch player’s business details
func get_business_info(player_id):
	return businesses.get(player_id, "No business owned")

# 📌 Handle economic recession effects
func apply_recession_effects():
	for biz in businesses.values():
		biz["growth_rate"] *= 0.9  # Businesses grow slower
		biz["monthly_profit"] *= 0.8  # Reduced income

# 📌 Handle business bankruptcy
func check_bankruptcies():
	for player_id in businesses.keys():
		if businesses[player_id]["value"] < 10_000:
			print("[Business] " + businesses[player_id]["name"] + " went bankrupt!")
			businesses.erase(player_id)
