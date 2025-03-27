extends Node
class_name BankingSystem

@onready var economy_manager = get_node("/root/EconomyManager")

var accounts = {}  # Dictionary storing bank accounts

# 📌 Open a bank account
func open_account(player_id):
	if player_id in accounts:
		print("[Bank] Player already has an account!")
		return false
	
	accounts[player_id] = {
		"balance": 1000.0,
		"savings_balance": 0.0,
		"loan_balance": 0.0,
		"credit_score": 700,
		"account_status": "Active"
	}
	print("[Bank] Account opened for Player " + str(player_id))
	return true

# 📌 Deposit money
func deposit(player_id, amount):
	if player_id in accounts:
		accounts[player_id]["balance"] += amount
		print("[Bank] Player " + str(player_id) + " deposited $" + str(amount))
		return true
	return false

# 📌 Withdraw money
func withdraw(player_id, amount):
	if player_id in accounts and accounts[player_id]["balance"] >= amount:
		accounts[player_id]["balance"] -= amount
		print("[Bank] Player " + str(player_id) + " withdrew $" + str(amount))
		return true
	return false

# 📌 Transfer money between players
func transfer(sender_id, receiver_id, amount):
	if sender_id in accounts and receiver_id in accounts and accounts[sender_id]["balance"] >= amount:
		accounts[sender_id]["balance"] -= amount
		accounts[receiver_id]["balance"] += amount
		print("[Bank] $" + str(amount) + " transferred from Player " + str(sender_id) + " to Player " + str(receiver_id))
		return true
	return false

# 📌 Take a loan (Dynamic Interest Rate)
func take_loan(player_id, amount):
	if player_id in accounts:
		var interest_rate = economy_manager.get_interest_rate()
		accounts[player_id]["loan_balance"] += amount * (1 + interest_rate)
		accounts[player_id]["balance"] += amount
		accounts[player_id]["credit_score"] -= 10  # Reduce credit score
		print("[Bank] Loan of $" + str(amount) + " taken by Player " + str(player_id) + " at " + str(interest_rate * 100) + "% interest")
		return true
	return false

# 📌 Repay loan
func repay_loan(player_id, amount):
	if player_id in accounts and accounts[player_id]["balance"] >= amount:
		accounts[player_id]["loan_balance"] -= amount
		accounts[player_id]["balance"] -= amount
		if accounts[player_id]["loan_balance"] <= 0:
			accounts[player_id]["credit_score"] += 20  # Reward good behavior
		print("[Bank] Loan repayment of $" + str(amount) + " made by Player " + str(player_id))
		return true
	return false

# 📌 Earn interest on savings (Dynamic Interest Rate)
func apply_interest():
	for player_id in accounts.keys():
		var interest_rate = economy_manager.get_interest_rate()
		accounts[player_id]["savings_balance"] *= (1 + interest_rate)
		print("[Bank] Interest applied for Player " + str(player_id) + ", New Savings: $" + str(accounts[player_id]["savings_balance"]))

# 📌 Check account details
func get_account_info(player_id):
	return accounts.get(player_id, "No account found!")

# 📌 AI-driven fraud detection (Example: Large withdrawals)
func detect_fraud(player_id, amount):
	if amount > accounts[player_id]["balance"] * 0.7:  # If withdrawal is > 70% of balance
		print("[Bank] 🚨 Possible fraud detected for Player " + str(player_id) + "!")
		return true
	return false
