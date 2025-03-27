extends Node
class_name AIChatbot

@onready var banking_system = get_node("/root/BankingSystem")
@onready var stock_market = get_node("/root/StockMarket")
@onready var business_simulator = get_node("/root/BusinessSimulator")
@onready var leaderboard = get_node("/root/Leaderboard")
@onready var economy_manager = get_node("/root/EconomyManager")

var knowledge_base = {
	"investing": "Investing in diversified assets reduces risk and increases long-term gains.",
	"budgeting": "Maintaining an emergency fund equal to 3-6 months of expenses is a wise strategy.",
	"stock_market": "Stock market trends can be volatile. Always check historical data before investing.",
	"tax_savings": "Using retirement accounts and tax-deductible investments can reduce taxable income.",
	"business": "Reinvesting profits into business expansion often leads to exponential growth."
}

# 📌 Process user queries
func respond_to_query(player_id, query):
	var response = analyze_player_financials(player_id, query)
	if response:
		return response
	else:
		return generate_default_response(query)

# 📌 Analyze financial data and provide personalized advice
func analyze_player_financials(player_id, query):
	var net_worth = leaderboard.calculate_net_worth(player_id)
	var stock_performance = stock_market.get_portfolio_value(player_id)
	var business_value = business_simulator.get_business_value(player_id)
	var cash_balance = banking_system.get_balance(player_id)

	if "invest" in query or "stock" in query:
		return suggest_stock_investment(player_id)
	elif "business" in query:
		return suggest_business_strategy(player_id)
	elif "budget" in query:
		return suggest_budget_plan(player_id)
	elif "tax" in query:
		return suggest_tax_strategy(player_id)
	elif "risk" in query:
		return assess_risk_profile(player_id)
	
	return null

# 📌 Stock investment suggestions
func suggest_stock_investment(player_id):
	var trending_stocks = stock_market.get_top_performing_stocks()
	return "Based on market trends, consider investing in " + str(trending_stocks[0]) + " for potential gains."

# 📌 Business strategy suggestions
func suggest_business_strategy(player_id):
	var player_business = business_simulator.get_business_summary(player_id)
	if player_business and player_business["profit"] < 0:
		return "Your business is running at a loss. Consider cutting operational costs or increasing marketing efforts."
	return "Your business is profitable! Reinvesting a percentage of profits could boost growth."

# 📌 Budgeting advice
func suggest_budget_plan(player_id):
	var cash_balance = banking_system.get_balance(player_id)
	if cash_balance < 500:
		return "Your cash reserves are low. Consider saving more and avoiding high-risk investments."
	return "You have a healthy cash balance. Consider allocating funds to long-term investments."

# 📌 Tax-saving strategies
func suggest_tax_strategy(player_id):
	return "Optimizing your tax strategy by investing in tax-deductible retirement accounts can reduce your liabilities."

# 📌 Assess risk profile
func assess_risk_profile(player_id):
	var portfolio = stock_market.get_portfolio_summary(player_id)
	var risk_score = 0
	for stock in portfolio:
		if stock["volatility"] > 0.7:
			risk_score += 1
	
	if risk_score > 2:
		return "Your portfolio carries high risk. Consider diversifying with stable investments."
	return "Your investment strategy is well-balanced."

# 📌 Generate default responses for unknown queries
func generate_default_response(query):
	for keyword in knowledge_base.keys():
		if keyword in query:
			return knowledge_base[keyword]
	return "I'm still learning. Try asking about investments, budgeting, or market trends."

# 📌 Log AI interaction for learning improvements
func log_interaction(player_id, query, response):
	print("[AI Chatbot] Player:", player_id, "Query:", query, "Response:", response)
