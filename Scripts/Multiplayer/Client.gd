extends Node3D
const port = 3789
var peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var client = peer.create_client(GlobalData.serverAddress, port)
	multiplayer.multiplayer_peer = peer
	pass # Replace with function body.
