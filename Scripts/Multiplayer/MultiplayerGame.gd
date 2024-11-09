extends Node3D
const port = 3789
var peer = ENetMultiplayerPeer.new()
var spectatorMode:bool
@export var playerScene: PackedScene
@onready var environment = $MultiplayerScene
# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalData.multiplayerMode == GlobalData.multiplayerModes.SERVER:
		spectatorMode = GlobalData.spectatorMode
		peer.create_server(port)
		multiplayer.multiplayer_peer = peer
		var playerName = multiplayer.peer_connected.get_name()
		multiplayer.peer_connected.connect(_add_player)
		if !spectatorMode:
			_add_player( )
		return
	var client = peer.create_client(GlobalData.serverAddress, port)
	multiplayer.multiplayer_peer = peer
	pass # Replace with function body.

func _add_player (id=1) :
	var player =playerScene.instantiate()
	self.add_child(player)
	player.player.name = str(id)
	call_deferred("add_child", player)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
