extends Node

var main_menu_scene: Resource = load("res://src/MainMenu.tscn")
var loading_menu_scene: Resource = load("res://src/LoadingMenu.tscn")
var lobby_scene: Resource = load("res://src/Lobby.tscn")

const MAX_PLAYERS = 5

var username: String
var game_ip: String
var game_port: int

var in_match: bool = false

var player_list: Array = []

# global signals
signal global_error

# lobby scene signals
signal ls_refresh_player_list

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("connected_to_server", self, "_connected_to_server")

func init_server(username: String, game_port: int) -> void:
	self.game_ip = "localhost"
	self.game_port = game_port
	self.username = username
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(game_port, 1)
	get_tree().network_peer = peer
	var player: Utils.Player = Utils.Player.new(1, username)
	player_list.append(player)
	get_tree().change_scene_to(lobby_scene)
	call_deferred("emit_signal", "ls_refresh_player_list")

func init_client(username: String, game_ip: String, game_port: int) -> void:
	get_tree().change_scene_to(loading_menu_scene)
	self.game_ip = game_ip
	self.game_port = game_port
	self.username = username
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(game_ip, game_port)
	get_tree().network_peer = peer

func _network_peer_connected(id: int) -> void:
	print(id, " connected")
	if (get_tree().is_network_server() && !in_match):
		rpc_id(id, "request_username")

func _network_peer_disconnected(id: int) -> void:
	print(id, " disconnected")
	if (get_tree().is_network_server()):
		for player in player_list:
			if (player.peer_id == id):
				rpc("player_disconnected", id)
	# HANDLE
	
func _server_disconnected() -> void:
	_network_peer_disconnected(1)

func _connection_failed() -> void:
	get_tree().change_scene_to(main_menu_scene)
	call_deferred("emit_signal", "global_error", "Connection Failed!")

func _connected_to_server() -> void:
	print("_connected_to_server")

# RPCs

puppet func request_username() -> void:
	get_tree().change_scene_to(lobby_scene)
	rpc_id(1, "login", username)

master func login(username: String) -> void:
	var user_id = get_tree().get_rpc_sender_id()
	for player in player_list:
		rpc_id(user_id, "add_player", player.peer_id, player.username)
	rpc("add_player", user_id, username)

remotesync func add_player(peer_id: int, username: String) -> void:
	if (get_tree().get_rpc_sender_id() == 1):
		var player: Utils.Player = Utils.Player.new(peer_id, username)
		player_list.append(player)
		call_deferred("emit_signal", "ls_refresh_player_list")

remotesync func player_disconnected(peer_id: int):
	if (get_tree().get_rpc_sender_id() == 1):
		for player in player_list:
			if (player.peer_id == peer_id):
				player_list.erase(player)
				call_deferred("emit_signal", "ls_refresh_player_list")
				if (in_match):
					# handle in match disconnect
					pass
