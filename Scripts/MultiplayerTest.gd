extends Node3D

#https://www.youtube.com/watch?v=K62jDMLPToA
@export var port:int 
var peer = ENetMultiplayerPeer.new()
@export var playerScene: PackedScene

func _add_player(id=1) :#for the host to play
	var player =playerScene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	pass



func _on_join_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	pass # Replace with function body.


func _on_host_pressed():
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	pass # Replace with function body.
