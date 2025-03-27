extends Node
class_name AIAdvisor

@onready var stock_market = get_node("/root/StockMarket")
@onready var game_manager = get_node("/root/GameManager")

var ai_personality = "balanced"  # Can be "aggressive", "conservative", or "balanced"

func _ready():
	print("[AI Advisor] Ready to assist with financial decisions!")

func analyze_player(player_id: String) -> Dictionary:
	if not game_manager.players_data.has(player_id):
		return {"error": "Player not found!"}
	
	var player = game_manager.players_data[player_id]
	var total_assets = player.get("coins", 0) + player.get("stocks_value", 0) + player.get("options_value", 0)
	var risk_level = determine_risk_level(player)

	return {
		"total_assets": total_assets,
		"risk_level": risk_level,
		"investment_advice": generate_investment_strategy(player),
		"stock_recommendations": recommend_stocks(player),
		"option_tips": recommend_options(player)
	}

func determine_risk_level(player: Dictionary) -> String:
	var net_worth = player.get("coins", 0) + player.get("stocks_value", 0)
	var debt = player.get("loans", 0)

	if debt > net_worth * 0.5:
		return "High Risk"
	elif debt > net_worth * 0.2:
		return "Moderate Risk"
	else:
		return "Low Risk"

func generate_investment_strategy(player: Dictionary) -> String:
	match ai_personality:
		"aggressive":
			return "Focus on high-growth stocks and options trading. Take advantage of short-term trends."
		"conservative":
			return "Invest in stable dividend-paying stocks and avoid high-risk assets."
		"balanced":
			return "Maintain a mix of stocks, bonds, and options to optimize returns with manageable risk."
	return "No strategy available."

func recommend_stocks(player: Dictionary) -> Array:
	var recommendations = []
	for stock in stock_market.stocks.keys():
		var stock_data = stock_market.stocks[stock]
		if ai_personality == "aggressive" and stock_data["volatility"] > 0.7:
			recommendations.append(stock)
		elif ai_personality == "conservative" and stock_data["dividend_yield"] > 3:
			recommendations.append(stock)
		elif ai_personality == "balanced" and stock_data["volatility"] > 0.3 and stock_data["dividend_yield"] > 1.5:
			recommendations.append(stock)
	return recommendations

func recommend_options(player: Dictionary) -> String:
	if ai_personality == "aggressive":
		return "Consider short-term call options on high-growth stocks."
	elif ai_personality == "conservative":
		return "Avoid options trading due to market risks."
	else:
		return "Use a mix of call and put options based on stock trends."

func change_ai_personality(new_personality: String):
	if new_personality in ["aggressive", "conservative", "balanced"]:
		ai_personality = new_personality
		print("[AI Advisor] Personality set to:", ai_personality)
	else:
		print("[AI Advisor] Invalid personality type.")

func get_ai_advice(player_id: String) -> Dictionary:
	return analyze_player(player_id)
