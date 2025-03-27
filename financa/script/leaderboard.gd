extends Node
class_name Leaderboard

@onready var banking_system = get_node("/root/BankingSystem")
@onready var stock_market = get_node("/root/StockMarket")
@onready var business_simulator = get_node("/root/BusinessSimulator")

var player_ranks = {}

# 📌 Update leaderboard based on total net worth
func update_leaderboard():
	player_ranks.clear()

	for player_id in banking_system.accounts.keys():
		var net_worth = calculate_net_worth(player_id)
		player_ranks[player_id] = net_worth
	
	# Sort by net worth in descending order
	var sorted_ranks = player_ranks.keys()
	sorted_ranks.sort_custom(func(a, b): return player_ranks[a] > player_ranks[b])

	print("[Leaderboard] Updated Rankings: ", player_ranks)
	return sorted_ranks

# 📌 Calculate player's total net worth
func calculate_net_worth(player_id):
	var net_worth = 0.0
	
	# Include cash balance
	net_worth += banking_system.accounts[player_id]["balance"]

	# Include stock market investments
	net_worth += stock_market.get_portfolio_value(player_id)

	# Include business value
	net_worth += business_simulator.get_business_value(player_id)

	return net_worth

# 📌 Get rank of a player
func get_player_rank(player_id):
	var sorted_ranks = update_leaderboard()
	return sorted_ranks.find(player_id) + 1 if player_id in sorted_ranks else -1

# 📌 Get top N players
func get_top_players(n = 5):
	var sorted_ranks = update_leaderboard()
	return sorted_ranks.slice(0, n)

# 📌 AI-driven financial insights for top players
func generate_financial_insights():
	var insights = {}
	var sorted_ranks = update_leaderboard()

	for i in range(min(3, sorted_ranks.size())):  # Top 3 players
		var player_id = sorted_ranks[i]
		var net_worth = player_ranks[player_id]
		
		insights[player_id] = {
			"rank": i + 1,
			"net_worth": net_worth,
			"stock_portfolio": stock_market.get_portfolio_summary(player_id),
			"business_performance": business_simulator.get_business_summary(player_id),
		}

	print("[Leaderboard] AI Insights Generated: ", insights)
	return insights

# 📌 Reward top players weekly
func distribute_weekly_rewards():
	var sorted_ranks = update_leaderboard()

	for i in range(min(5, sorted_ranks.size())):  # Top 5 players get rewards
		var player_id = sorted_ranks[i]
		var reward = (5 - i) * 500  # Higher rank = bigger reward
		banking_system.deposit(player_id, reward)
		print("[Leaderboard] Player " + str(player_id) + " received $" + str(reward) + " for weekly ranking!")
