extends Node
class_name Utils

class Player:
	var peer_id: int
	var username: String
	
	func _init(peer_id: int, username: String):
		self.peer_id = peer_id
		self.username = username
