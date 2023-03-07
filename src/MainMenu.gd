extends Control

onready var error_label: Node = $CenterContainer/VBoxContainer/ErrorLabel

onready var username_input: Node = $CenterContainer/VBoxContainer/GridContainer/UNInput
onready var ip_input: Node = $CenterContainer/VBoxContainer/GridContainer/IPInput
onready var port_input: Node = $CenterContainer/VBoxContainer/GridContainer/PortInput

func _ready() -> void:
	Gamestate.connect("global_error", self, "_global_error")
	error_label.visible = false

func do_error(msg: String) -> void:
	error_label.text = msg
	error_label.visible = true

func _on_ConnectBTN_pressed() -> void:
	var username: String = username_input.text
	var ip: String = ip_input.text
	var port: int = int(port_input.text)
	
	if (username.replace(" ", "") == "" || ip.replace(" ", "") == "" || port == 0):
		do_error("Please fill all fields!")
		return
	
	Gamestate.init_client(username, ip, port)

func _on_HostBTN_pressed() -> void:
	var username: String = username_input.text
	var port: int = int(port_input.text)
	
	if (username.replace(" ", "") == "" || port == 0):
		do_error("Please fill the username and port fields!")
		return
	
	Gamestate.init_server(username, port)

func _global_error(msg: String) -> void:
	do_error(msg)
