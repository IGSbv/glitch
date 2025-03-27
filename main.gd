extends Node

# Player resources
var coins: int = 0
var gems: int = 5

# Stores previous decisions for time travel
var decision_history: Array = []

# Decision structure
class Decision:
	var description: String
	var coin_reward: int
	var gem_reward: int
	
	func _init(desc, coin_r, gem_r):
		description = desc
		coin_reward = coin_r
		gem_reward = gem_r

# Example financial decisions
var decisions = [
	Decision.new("Invest in stocks", 100, 1),
	Decision.new("Save money", 50, 2),
	Decision.new("Buy an expensive car", -200, -1)
]

# Executes a decision
func make_decision(decision: Decision):
	decision_history.append({"coins": coins, "gems": gems}) # Save state
	coins += decision.coin_reward
	gems += decision.gem_reward
	print("Decision made: " + decision.description)
	print("Coins: %d, Gems: %d" % [coins, gems])

# Rewind time using gems
func undo_last_decision():
	if decision_history.size() > 0 and gems > 0:
		var last_state = decision_history.pop_back()
		coins = last_state["coins"]
		gems = last_state["gems"] - 1 # Spend 1 gem for undo
		print("Time travel activated! Reverting to previous state.")
		print("Coins: %d, Gems: %d" % [coins, gems])
	else:
		print("Not enough gems or no decisions to undo!")

# Example game loop
func _ready():
	print("Welcome to the Financial Decision Game!")
	
	# Simulating choices
	make_decision(decisions[0]) # Invest in stocks
	make_decision(decisions[2]) # Buy an expensive car
	
	# Undo last decision
	undo_last_decision()
