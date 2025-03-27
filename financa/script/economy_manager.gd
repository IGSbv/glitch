extends Node
class_name EconomyManager

@onready var stock_market = get_node("/root/StockMarket")
@onready var finance_news = get_node("/root/FinanceNewsGenerator")

# Global economy variables
var gdp_growth = 2.5  # % GDP growth per cycle
var inflation_rate = 2.0  # % inflation rate
var interest_rate = 1.5  # % interest rate set by central bank
var economic_cycle = "Expansion"  # ["Boom", "Recession", "Crisis", "Recovery", "Expansion"]

var cycle_duration = 60  # Time (seconds) for each economic cycle phase
var cycle_timer = 0

func _ready():
	print("[Economy] Manager Initialized")
	update_economic_cycle()

func _process(delta):
	cycle_timer += delta
	if cycle_timer >= cycle_duration:
		cycle_timer = 0
		update_economic_cycle()

# 📌 Updates the economic cycle every fixed interval
func update_economic_cycle():
	var random_factor = randf_range(-1.0, 1.0)
	match economic_cycle:
		"Boom":
			gdp_growth = randf_range(3.5, 5.5) + random_factor
			inflation_rate = randf_range(2.5, 4.5) + random_factor
			interest_rate = randf_range(1.5, 3.0) + random_factor
			economic_cycle = "Expansion"
		"Expansion":
			gdp_growth = randf_range(2.0, 3.5) + random_factor
			inflation_rate = randf_range(1.5, 3.0) + random_factor
			interest_rate = randf_range(1.0, 2.5) + random_factor
			economic_cycle = "Recession" if randf() < 0.3 else "Boom"
		"Recession":
			gdp_growth = randf_range(-1.5, 1.5) + random_factor
			inflation_rate = randf_range(0.5, 2.0) + random_factor
			interest_rate = randf_range(0.5, 1.5) + random_factor
			economic_cycle = "Crisis" if randf() < 0.2 else "Recovery"
		"Crisis":
			gdp_growth = randf_range(-3.0, -1.0) + random_factor
			inflation_rate = randf_range(-1.0, 1.0) + random_factor
			interest_rate = randf_range(0.0, 0.5) + random_factor
			economic_cycle = "Recovery"
		"Recovery":
			gdp_growth = randf_range(1.0, 2.5) + random_factor
			inflation_rate = randf_range(1.0, 2.5) + random_factor
			interest_rate = randf_range(0.5, 2.0) + random_factor
			economic_cycle = "Expansion"

	print("[Economy] New Cycle: " + economic_cycle)
	finance_news.generate_random_news()  # Generate financial news based on economic shift
	apply_economic_impact()

# 📌 Adjusts stock market, taxes, and financial systems based on economy
func apply_economic_impact():
	# 🔺 Inflation affects expenses
	var inflation_multiplier = 1.0 + (inflation_rate / 100)
	
	# 🔻 Interest rates affect borrowing & investments
	var interest_multiplier = 1.0 + (interest_rate / 100)

	# 💹 Adjust stock market volatility based on economy
	for stock in stock_market.stocks.keys():
		stock_market.stocks[stock]["volatility"] *= inflation_multiplier
		stock_market.stocks[stock]["current_price"] *= (1.0 + gdp_growth / 100)

	print("[Economy] Applied changes: Inflation =", inflation_rate, "%, Interest =", interest_rate, "%")

# 📌 Fetches current economic status
func get_economy_status():
	return {
		"GDP Growth": gdp_growth,
		"Inflation Rate": inflation_rate,
		"Interest Rate": interest_rate,
		"Economic Cycle": economic_cycle
	}
