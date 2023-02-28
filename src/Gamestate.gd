extends Node

var main_menu_scene: Resource = load("res://src/MainMenu.tscn")
var loading_menu_scene: Resource = load("res://src/LoadingMenu.tscn")

const MAX_PLAYERS = 5

var username: String
var game_ip: String
var game_port: int

signal global_error

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
	if (is_network_master()):
		rpc_id(id, "request_username")

func _network_peer_disconnected(id: int) -> void:
	print(id, " disconnected")
	# HANDLE
	
func _server_disconnected() -> void:
	_network_peer_disconnected(1)

func _connection_failed() -> void:
	get_tree().change_scene_to(main_menu_scene)
	call_deferred("emit_signal", "global_error", "Connection Failed!")

func _connected_to_server() -> void:
	print("_connected_to_server")
