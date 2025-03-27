extends Node
class_name NetworkManager

const PORT = 4242
var peer = null

signal player_connected(id)
signal player_disconnected(id)

func _ready():
	print("[Network] Network Manager Initialized")

func start_host():
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT, 4)  # Supports up to 4 players
	if err != OK:
		print("[Error] Failed to start server:", err)
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	print("[Server] Hosting started on port", PORT)

func join_server(ip_address: String):
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip_address, PORT)
	if err != OK:
		print("[Error] Failed to join server:", err)
		return
	multiplayer.multiplayer_peer = peer
	print("[Client] Connected to server at", ip_address)

func _on_player_connected(id):
	print("[Network] Player", id, "connected")
	player_connected.emit(id)

func _on_player_disconnected(id):
	print("[Network] Player", id, "disconnected")
	player_disconnected.emit(id)
