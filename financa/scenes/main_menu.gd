extends Control

func _ready():
	print("🏆 Welcome to the Financial Decision Game! 🏆")
	
func on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")

func on_load_pressed():
	print("🔄 Loading saved game...")  # Implement save/load system

func on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func on_chatbot_pressed():
	get_tree().change_scene_to_file("res://scenes/ai_chatbot.tscn")

func on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func on_exit_pressed():
	get_tree().quit()
