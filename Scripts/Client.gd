extends Node

const ADDRESS = "localhost"
const PORT = 3789

var peer = ENetMultiplayerPeer.new()
func _ready():
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	pass
