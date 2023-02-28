extends Control

onready var error_label: Node = $CenterContainer/VBoxContainer/ErrorLabel

onready var username_input: Node = $CenterContainer/VBoxContainer/GridContainer/UNInput
onready var ip_input: Node = $CenterContainer/VBoxContainer/GridContainer/IPInput
onready var port_input: Node = $CenterContainer/VBoxContainer/GridContainer/PortInput

func _ready():
	error_label.visible = false

func do_error(msg: String):
	error_label.text = msg
	error_label.visible = true

func _on_ConnectBTN_pressed():
	var username: String = username_input.text
	var ip: String = ip_input.text
	var port: int = int(port_input.text)
	
	if (username.replace(" ", "") == "" || ip.replace(" ", "") == "" || port == 0):
		do_error("Please fill all fields!")
		return
	
	# Connect

func _on_HostBTN_pressed():
	var username: String = username_input.text
	var port: int = int(port_input.text)
	
	if (username.replace(" ", "") == "" || port == 0):
		do_error("Please fill the username and port fields!")
		return
	
	# Host
