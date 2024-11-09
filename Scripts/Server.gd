extends Node3D

#https://www.youtube.com/watch?v=K62jDMLPToA
#@export var port:int 
var port = 3789
var peer = ENetMultiplayerPeer.new()
@export var playerScene: PackedScene
var spectatorMode: bool = false
var lastUsername:String = "Host"
func _ready():
	spectatorMode = GlobalData.spectatorMode
	print(spectatorMode)
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	var playerName = multiplayer.peer_connected.get_name()
	multiplayer.peer_connected.connect(_add_player)
	if !spectatorMode:
		_add_player( )
	pass

func _add_player (id=1) :
	var player =playerScene.instantiate()
	$Escenario.add_child(player)
	#call_deferred("add_child", player)
	player.username = lastUsername
	player.player.name = str(id)
	
	pass



#func _on_join_pressed():
	#peer.create_client("localhost", port)
	#multiplayer.multiplayer_peer = peer
	#pass # Replace with function body.


#func _on_host_pressed():
	#peer.create_server(port)
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(_add_player)
	#_add_player()
	#pass 
