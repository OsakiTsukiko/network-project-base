extends Control

onready var player_list_node: Node = $CenterContainer/VBoxContainer/PlayerList
onready var start_btn: Node = $CenterContainer/VBoxContainer/StartBTN

func _ready() -> void:
	Gamestate.connect("ls_refresh_player_list", self, "_refresh_player_list")
	if (get_tree().is_network_server()):
		start_btn.visible = true
	else:
		start_btn.visible = false

func _refresh_player_list():
	player_list_node.clear()
	for player in Gamestate.player_list:
		player_list_node.add_item(player.username, null, false)
