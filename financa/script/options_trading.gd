extends Node
class_name OptionsTrading

@onready var stock_market = get_node("/root/StockMarket")
@onready var game_manager = get_node("/root/GameManager")

var options_market = {}  # Store available options contracts

func _ready():
	generate_initial_options()

func generate_initial_options():
	for stock in stock_market.stocks.keys():
		var current_price = stock_market.stocks[stock]["price"]
		options_market[stock] = {
			"call": {"strike_price": current_price * 1.1, "premium": 5.0, "expiration": 7},
			"put": {"strike_price": current_price * 0.9, "premium": 5.0, "expiration": 7}
		}

func update_options_market():
	for stock in stock_market.stocks.keys():
		var current_price = stock_market.stocks[stock]["price"]
		var volatility = stock_market.stocks[stock]["volatility"]
		
		options_market[stock]["call"]["strike_price"] = current_price * (1.05 + randf_range(0, volatility))
		options_market[stock]["put"]["strike_price"] = current_price * (0.95 - randf_range(0, volatility))
		options_market[stock]["call"]["premium"] = max(1.0, options_market[stock]["call"]["premium"] + randf_range(-1, 1))
		options_market[stock]["put"]["premium"] = max(1.0, options_market[stock]["put"]["premium"] + randf_range(-1, 1))
		
		print("[Options Market] Updated:", stock, options_market[stock])

func buy_option(player_id: String, stock_name: String, option_type: String, quantity: int):
	if not game_manager.players_data.has(player_id):
		print("[Options] Error: Player not found!")
		return
	if not options_market.has(stock_name) or not options_market[stock_name].has(option_type):
		print("[Options] Error: Invalid stock or option type")
		return

	var player = game_manager.players_data[player_id]
	var total_cost = options_market[stock_name][option_type]["premium"] * quantity

	if player["coins"] < total_cost:
		print("[Options] Not enough coins!")
		return

	player["coins"] -= total_cost

	if not player.has("options_portfolio"):
		player["options_portfolio"] = {}

	if not player["options_portfolio"].has(stock_name):
		player["options_portfolio"][stock_name] = {"call": 0, "put": 0}

	player["options_portfolio"][stock_name][option_type] += quantity
	print("[Options] Player", player_id, "bought", quantity, option_type, "options on", stock_name)

func exercise_option(player_id: String, stock_name: String, option_type: String):
	if not game_manager.players_data.has(player_id):
		print("[Options] Error: Player not found!")
		return
	if not options_market.has(stock_name) or not options_market[stock_name].has(option_type):
		print("[Options] Error: Invalid stock or option type")
		return

	var player = game_manager.players_data[player_id]
	if not player.has("options_portfolio") or not player["options_portfolio"].has(stock_name) or player["options_portfolio"][stock_name][option_type] == 0:
		print("[Options] Error: No options to exercise!")
		return

	var stock_price = stock_market.stocks[stock_name]["price"]
	var strike_price = options_market[stock_name][option_type]["strike_price"]
	var quantity = player["options_portfolio"][stock_name][option_type]

	if option_type == "call" and stock_price > strike_price:
		var profit = (stock_price - strike_price) * quantity
		player["coins"] += profit
		print("[Options] Player", player_id, "exercised", quantity, "call options on", stock_name, "for", profit, "coins")
	elif option_type == "put" and stock_price < strike_price:
		var profit = (strike_price - stock_price) * quantity
		player["coins"] += profit
		print("[Options] Player", player_id, "exercised", quantity, "put options on", stock_name, "for", profit, "coins")
	else:
		print("[Options] Expired worthless.")

	player["options_portfolio"][stock_name][option_type] = 0  # Remove used options

func get_options_market():
	return options_market
