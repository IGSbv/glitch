extends Node
class_name MarketSentiment

@onready var stock_market = get_node("/root/StockMarket")

var sentiment_score = 0.0  # Ranges from -1 (bearish) to +1 (bullish)
var event_impact = 0.0  # Additional market shocks (e.g., economic recessions)
var recent_trading_volume = {}  # Tracks how much each stock is traded

func _ready():
	print("[Market Sentiment] System Initialized")
	update_sentiment()

# 📌 Updates market sentiment based on stock performance & events
func update_sentiment():
	var total_movement = 0.0
	var stock_count = stock_market.stocks.size()

	for stock in stock_market.stocks.keys():
		var stock_data = stock_market.stocks[stock]
		var price_change = stock_data["current_price"] - stock_data["previous_price"]
		total_movement += price_change

	sentiment_score = clamp(total_movement / stock_count + event_impact, -1.0, 1.0)
	event_impact = 0.0  # Reset event impact after calculation

	print("[Market Sentiment] Updated! Score:", sentiment_score)

# 📌 Applies market sentiment effect on stock prices
func apply_sentiment_to_market():
	for stock in stock_market.stocks.keys():
		var stock_data = stock_market.stocks[stock]
		var price_shift = stock_data["volatility"] * sentiment_score * randf_range(0.8, 1.2)
		stock_data["current_price"] += price_shift
		stock_market.stocks[stock] = stock_data

# 📌 Influences market sentiment based on player trading behavior
func track_trading_activity(stock_symbol: String, action: String):
	if not recent_trading_volume.has(stock_symbol):
		recent_trading_volume[stock_symbol] = 0
	
	recent_trading_volume[stock_symbol] += 1 if action == "buy" else -1
	adjust_sentiment_based_on_trading()

# 📌 Adjusts sentiment based on high trading volume
func adjust_sentiment_based_on_trading():
	var bullish_activity = 0
	var bearish_activity = 0

	for stock in recent_trading_volume.keys():
		if recent_trading_volume[stock] > 5:
			bullish_activity += 1
		elif recent_trading_volume[stock] < -5:
			bearish_activity += 1

	sentiment_score += (bullish_activity - bearish_activity) * 0.05
	sentiment_score = clamp(sentiment_score, -1.0, 1.0)

# 📌 Adds economic events affecting sentiment
func trigger_market_event(event_type: String):
	match event_type:
		"recession":
			event_impact = -0.6  # Strong negative impact
		"bull_run":
			event_impact = 0.7  # Strong positive impact
		"interest_rate_hike":
			event_impact = -0.3  # Moderate impact
		"tech_boom":
			event_impact = 0.5  # Boosts sentiment
		_:
			event_impact = 0.0  # No effect

	update_sentiment()
