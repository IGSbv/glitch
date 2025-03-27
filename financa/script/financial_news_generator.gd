extends Node
class_name FinanceNewsGenerator

@onready var market_sentiment = get_node("/root/MarketSentiment")
@onready var stock_market = get_node("/root/StockMarket")

var news_list = []
var news_impact = {}

func _ready():
	print("[Finance News] Generator Initialized")
	generate_random_news()

# 📌 Generates random financial news and affects market sentiment
func generate_random_news():
	var random_event = randi() % 5  # Pick a random event
	var news = ""
	var impact = 0.0  # Impact on sentiment

	match random_event:
		0:
			news = "📈 Tech Stocks Soar as AI Boom Continues!"
			impact = 0.5
			apply_news_impact("Technology", impact)
		1:
			news = "📉 Economic Recession Looming? Investors Panic!"
			impact = -0.7
			apply_news_impact("Market", impact)
		2:
			news = "⚡ Interest Rate Hike Announced – Bonds Surge, Stocks Fall!"
			impact = -0.4
			apply_news_impact("Finance", impact)
		3:
			news = "🚀 New Crypto Regulation Boosts Blockchain Stocks!"
			impact = 0.6
			apply_news_impact("Blockchain", impact)
		4:
			news = "📊 Strong GDP Growth Reported – Bull Market Expected!"
			impact = 0.4
			apply_news_impact("Market", impact)

	news_list.append(news)
	print("[Finance News] Breaking: " + news)

# 📌 Applies news impact on stock market
func apply_news_impact(category: String, sentiment_change: float):
	if category == "Market":
		market_sentiment.event_impact += sentiment_change
	else:
		for stock in stock_market.stocks.keys():
			if stock_market.stocks[stock]["sector"] == category:
				var price_change = stock_market.stocks[stock]["volatility"] * sentiment_change
				stock_market.stocks[stock]["current_price"] += price_change

	market_sentiment.update_sentiment()

# 📌 Fetch latest financial news
func get_latest_news():
	return news_list.slice(max(0, news_list.size() - 5), news_list.size())  # Return last 5 news events
