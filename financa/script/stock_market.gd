extends Node
class_name StockMarket

@onready var game_manager = get_node("/root/GameManager")

var stocks = {
	"TechCorp": {"price": 100.0, "volatility": 0.05},
	"GreenEnergy": {"price": 75.0, "volatility": 0.08},
	"BankSecure": {"price": 120.0, "volatility": 0.03},
	"AutoFast": {"price": 90.0, "volatility": 0.06}
}

var stock_trends = {}

func _ready():
	generate_initial_trends()

func generate_initial_trends():
	for stock in stocks.keys():
		stock_trends[stock] = randf_range(-0.02, 0.02)  # Random initial trend (-2% to +2%)

func update_stock_prices():
	for stock in stocks.keys():
		var trend = stock_trends[stock]
		var volatility = stocks[stock]["volatility"]
		var price_change = stocks[stock]["price"] * (trend + randf_range(-volatility, volatility))
		
		stocks[stock]["price"] += price_change
		stocks[stock]["price"] = max(1.0, stocks[stock]["price"])  # Prevent stock prices from going negative

		print("[Stock Market] Updated price of", stock, "to", stocks[stock]["price"])

func buy_stock(player_id: String, stock_name: String, quantity: int):
	if not game_manager.players_data.has(player_id):
		print("[Stock Market] Error: Player data not found for ID:", player_id)
		return

	var player = game_manager.players_data[player_id]
	if not stocks.has(stock_name):
		print("[Stock Market] Error: Stock not found:", stock_name)
		return

	var total_cost = stocks[stock_name]["price"] * quantity
	if player["coins"] < total_cost:
		print("[Stock Market] Not enough coins to buy", stock_name)
		return

	player["coins"] -= total_cost

	if not player.has("portfolio"):
		player["portfolio"] = {}

	if not player["portfolio"].has(stock_name):
		player["portfolio"][stock_name] = 0

	player["portfolio"][stock_name] += quantity
	print("[Stock Market] Player", player_id, "bought", quantity, "shares of", stock_name)

func sell_stock(player_id: String, stock_name: String, quantity: int):
	if not game_manager.players_data.has(player_id):
		print("[Stock Market] Error: Player data not found for ID:", player_id)
		return

	var player = game_manager.players_data[player_id]
	if not stocks.has(stock_name):
		print("[Stock Market] Error: Stock not found:", stock_name)
		return

	if not player.has("portfolio") or not player["portfolio"].has(stock_name) or player["portfolio"][stock_name] < quantity:
		print("[Stock Market] Not enough shares to sell:", stock_name)
		return

	var total_earnings = stocks[stock_name]["price"] * quantity
	player["coins"] += total_earnings
	player["portfolio"][stock_name] -= quantity

	if player["portfolio"][stock_name] == 0:
		player["portfolio"].erase(stock_name)  # Remove stock if sold out

	print("[Stock Market] Player", player_id, "sold", quantity, "shares of", stock_name, "for", total_earnings, "coins")

func get_stock_prices():
	return stocks
