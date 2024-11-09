extends Node3D

#https://www.youtube.com/watch?v=K62jDMLPToA
#@export var port:int 
var port = 3789
var peer = ENetMultiplayerPeer.new()
@export var playerScene: PackedScene
func _ready():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(_add_player)
	#_add_player()
	pass

func _add_player(id=1) :#for the host to play
	var player =playerScene.instantiate()
	$Escenario.add_child(player)
	player.name = str(id)
	call_deferred("add_child", player)
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
